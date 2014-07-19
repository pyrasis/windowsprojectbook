#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# tracversion-date.ps1 <Trac env> <Project name>

$trac_env = "C:\trac\" + $args[0]
$project = $args[1]
$ccnet_dir = "C:\Program Files\CruiseControl.NET\server\"

$date = (get-date -uformat %Y)+"."+(get-date -format %M.%d)
[xml]$state_file = get-content -path $ccnet_dir$project.state

if ($state_file.IntegrationResult.Label -match $date)
{
	$full_date = $date+"."

	[int]$next_version = $state_file.IntegrationResult.Label -replace $full_date, ""
	if ($state_file.IntegrationResult.Status -match "Success")
	{
		$next_version++
	}
}
else
{
	$next_version = "1"
}

$version_string = $date+"."+$next_version

C:\Python25\Scripts\trac-admin.exe $trac_env version add $version_string

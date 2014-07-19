#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# tracversion.ps1 <Trac env> <Project name>

$trac_env = "C:\trac\" + $args[0]
$project = $args[1]
$ccnet_dir = "C:\Program Files\CruiseControl.NET\server\"

[xml]$state_file = get-content -path $ccnet_dir$project.state

if ($state_file.IntegrationResult.Label)
{
	$version = $state_file.IntegrationResult.Label.split(".")
	[int]$next_version = $version[3]

	if ($state_file.IntegrationResult.Status -match "Success")
	{
		$next_version++
	}

	$version_string = $version[0] + "." + $version[1] + "." + $version[2] + "." + $next_version
}
else
{
	$version_string = "0.0.0.0"
}

C:\Python25\Scripts\trac-admin.exe $trac_env version add $version_string

#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# rcversion.ps1 <Project name> <Resource file Path>

if ($args.count -eq 0)
{
	"Usage: rcversion.ps1 <Project name> <Resourc file Path>"
	exit
}

$project = $args[0]
$rc_file_path = $args[1]
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

	$version_string = $version[0] + ", " + $version[1] + ", " + $version[2] + ", " + $next_version
}
else
{
	$version_string = "0, 0, 0, 0"
}

# Resource file Update.
$rc_file = get-content -path $rc_file_path
$rc_length = $rc_file.Length

for ($i = 0; $i -lt $rc_length; $i++)
{
	if ($rc_file[$i] -match " FILEVERSION ")
	{
		$rc_file[$i] = " FILEVERSION "+$version_string
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "            VALUE `"FileVersion`", ")
	{
		$rc_file[$i] = "            VALUE `"FileVersion`", `""+$version_string+"`""
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match " PRODUCTVERSION ")
	{
		$rc_file[$i] = " PRODUCTVERSION "+$version_string
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "            VALUE `"ProductVersion`", ")
	{
		$rc_file[$i] = "            VALUE `"ProductVersion`", `""+$version_string+"`""
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "#define FILEVER ")
	{
		$rc_file[$i] = "#define FILEVER "+$version_string
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "#define STRFILEVER ")
	{
		$rc_file[$i] = "#define STRFILEVER `""+$version_string+"\0"+"`""
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "#define PRODUCTVER ")
	{
		$rc_file[$i] = "#define PRODUCTVER "+$version_string
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "#define STRPRODUCTVER ")
	{
		$rc_file[$i] = "#define STRPRODUCTVER `""+$version_string+"\0"+"`""
		echo "Product Version Updated"
	}
}

set-content -path $rc_file_path $rc_file

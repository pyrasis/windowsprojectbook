#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

$backup_dir = "C:\Backup"
$url = "file:///" + $backup_dir.Replace("\","/")

new-item -path $backup_dir -type directory -force

foreach ($item in get-childitem $backup_dir)
{
	if (test-path "$backup_dir\$item" -pathtype container)
	{
		svnsync sync $url/$item
	}
}

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
$trac_dir = "C:\trac"

new-item -path $backup_dir -type directory -force
new-item -path $backup_dir\trac -type directory -force

$today = (Get-Date).tostring('yyyyMMdd')+"."+(Get-date -uformat %j)

new-item -path $backup_dir\trac\$today -type directory -force

foreach ($item in get-childitem $trac_dir)
{
	if (test-path "$trac_dir\$item" -pathtype container)
	{
		C:\Python25\Scripts\trac-admin.exe $trac_dir\$item hotcopy $backup_dir\trac\$today\$item
	}
}

[int] $delete_day = (Get-Date -uformat %j) -30
Remove-Item $backup_dir\trac\*.$delete_day -recurse -force

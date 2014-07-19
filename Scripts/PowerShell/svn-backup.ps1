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
$repos_dir = "C:\Repos"

new-item -path $backup_dir -type directory -force
new-item -path $backup_dir\Repos -type directory -force

$today = (Get-Date).tostring('yyyyMMdd')+"."+(Get-date -uformat %j)

new-item -path $backup_dir\Repos\$today -type directory -force

foreach ($item in get-childitem $repos_dir)
{
	if (test-path "$repos_dir\$item" -pathtype container)
	{
		svnadmin hotcopy $repos_dir\$item $backup_dir\Repos\$today\$item
	}
}

copy $repos_dir\htpasswd $backup_dir\Repos\$today
copy $repos_dir\authz $backup_dir\Repos\$today

[int] $delete_day = (Get-Date -uformat %j) -30
Remove-Item $backup_dir\Repos\*.$delete_day -recurse -force

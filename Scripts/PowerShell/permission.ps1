#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#
# File Info:
#     $LastChangedRevision: 225 $
#

$tracenv_dir = "C:\trac"
$trac_admin = "C:\Python25\Scripts\trac-admin.exe"
$item = $args[0]

.$trac_admin $tracenv_dir\$item permission add hellouser developer
.$trac_admin $tracenv_dir\$item permission add worlduser developer

.$trac_admin $tracenv_dir\$item permission add developer TICKET_CREATE
.$trac_admin $tracenv_dir\$item permission add developer TICKET_MODIFY
.$trac_admin $tracenv_dir\$item permission add developer WIKI_CREATE
.$trac_admin $tracenv_dir\$item permission add developer WIKI_MODIFY
.$trac_admin $tracenv_dir\$item permission add developer BROWSER_VIEW
.$trac_admin $tracenv_dir\$item permission add developer FILE_VIEW

.$trac_admin $tracenv_dir\$item permission remove anonymous BROWSER_VIEW
.$trac_admin $tracenv_dir\$item permission remove anonymous FILE_VIEW
.$trac_admin $tracenv_dir\$item permission remove anonymous TICKET_CREATE
.$trac_admin $tracenv_dir\$item permission remove anonymous TICKET_MODIFY
.$trac_admin $tracenv_dir\$item permission remove anonymous WIKI_CREATE
.$trac_admin $tracenv_dir\$item permission remove anonymous WIKI_MODIFY


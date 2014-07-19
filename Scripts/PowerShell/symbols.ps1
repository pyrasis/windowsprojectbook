#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# symbols.ps1 <Source root> <Symbol root> <Project name>

$source_root = $args[0]
$symbol_root = $args[1]
$project = $args[2]

cd $source_root
svnindex.cmd /symbols=$symbol_root /debug
symstore.exe add /o /r /f $args[1] /s C:\Symbols /t "$project" /compress

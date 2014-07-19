#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# revert.ps1 <Source Path>

$source_dir = $args[0]

svn revert -R $source_dir

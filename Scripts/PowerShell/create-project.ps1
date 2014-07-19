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
#     $LastChangedRevision: 55 $
#

$tracenv_dir = "C:\trac"
$repos_dir = "C:\Repos"
$repos_svnpath = "file:///c:/repos"
$trac_admin = "C:\Python25\Scripts\trac-admin.exe"

if ($args.count -eq 0)
{
    "Usage: create-project.ps1 <ProjectName>"
    exit
}

$project = $args[0]

# Subversion 저장소 생성
svnadmin.exe create $repos_dir\$project

# trunk, branches, tags 디렉토리 생성
svn mkdir -m "Default Directories" $repos_svnpath/$project/trunk $repos_svnpath/$project/branches $repos_svnpath/$project/tags

# trac 프로젝트 생성
.$trac_admin $tracenv_dir\$project initenv $project sqlite:db/trac.db svn $repos_dir\$project

# example 프로젝트의 trac.ini 파일을 새로 만드는 프로젝트로 복사. trac.ini 내용을 새 프로젝트 이름으로 변경
$tracini = get-content $tracenv_dir\example\conf\trac.ini
$tracini = $tracini -replace "example", $project
$tracini = $tracini -replace "My example project", ""
$tracini | out-file -encoding oem $tracenv_dir\$project\conf\trac.ini

# Hook 스크립트를 새로 만드는 프로젝트로 복사. 스크립트의 내용을 새 프로젝트 이름으로 변경
$pre_commit = get-content $repos_dir\example\hooks\pre-commit.cmd
$pre_commit = $pre_commit -replace "example", $project
$pre_commit | out-file -encoding oem $repos_dir\$project\hooks\pre-commit.cmd
$post_commit = get-content $repos_dir\example\hooks\post-commit.cmd
$post_commit = $post_commit -replace "example", $project
$post_commit | out-file -encoding oem $repos_dir\$project\hooks\post-commit.cmd
$post_revprop_change = get-content $repos_dir\example\hooks\post-revprop-change.cmd
$post_revprop_change = $post_revprop_change -replace "example", $project
$post_revprop_change | out-file -encoding oem $repos_dir\$project\hooks\post-revprop-change.cmd
copy $repos_dir\example\hooks\pre-revprop-change.cmd $repos_dir\$project\hooks\

# trac 프로젝트를 최신 상태로 갱신, admin 계정에 TRAC_ADMIN 권한 부여
.$trac_admin $tracenv_dir\$project upgrade
.$trac_admin $tracenv_dir\$project resync
.$trac_admin $tracenv_dir\$project permission add admin TRAC_ADMIN

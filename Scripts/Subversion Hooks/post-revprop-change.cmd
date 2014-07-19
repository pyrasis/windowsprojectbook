@ECHO OFF
REM POST-REVPROP-CHANGE HOOK
REM
REM The post-revprop-change hook is invoked after a revision property
REM has been added, modified or deleted.  Subversion runs this hook by
REM invoking a program (script, executable, binary, etc.) named
REM 'post-revprop-change' (for which this file is a template), with the
REM following ordered arguments:
REM
REM   [1] REPOS-PATH   (the path to this repository)
REM   [2] REV          (the revision that was tweaked)
REM   [3] USER         (the username of the person tweaking the property)
REM   [4] PROPNAME     (the property that was changed)
REM   [5] ACTION       (the property was 'A'dded, 'M'odified, or 'D'eleted)
REM
REM   [STDIN] PROPVAL  ** the old property value is passed via STDIN.
REM
REM Because the propchange has already completed and cannot be undone,
REM the exit code of the hook program is ignored.  The hook program
REM can use the 'svnlook' utility to help it examine the
REM new property value.
REM
REM On a Unix system, the normal procedure is to have 'post-revprop-change'
REM invoke other programs to do the real work, though it may do the
REM work itself too.
REM
REM Note that 'post-revprop-change' must be executable by the user(s) who will
REM invoke it (typically the user httpd runs as), and that user must
REM have filesystem-level permission to access the repository.
REM
REM On a Windows system, you should name the hook program
REM 'post-revprop-change.bat' or 'post-revprop-change.exe',
REM but the basic idea is the same.
REM 
REM The hook program typically does not inherit the environment of
REM its parent process.  For example, a common problem is for the
REM PATH environment variable to not be set to its usual value, so
REM that subprograms fail to launch unless invoked via absolute path.
REM If you're having unexpected problems with a hook program, the
REM culprit may be unusual (or missing) environment variables.
REM 
REM Here is an example hook script, for a Unix /bin/sh interpreter.
REM For more examples and pre-written hooks, see those in
REM the Subversion repository at
REM http://svn.collab.net/repos/svn/trunk/tools/hook-scripts/ and
REM http://svn.collab.net/repos/svn/trunk/contrib/hook-scripts/

SET REPOS=%1
SET REV=%2
SET USER=%3
SET PROPNAME=%4
SET ACTION=%5

SET PROJECT=sample
SET HOSTNAME=sample.com
SET EMAIL=source-changes@sample-mail.com

SET TOOLS_DIR="C:\tools"
SET SVN_DIR=C:\Program Files\Subversion

SET SVNLOOK="%SVN_DIR%\bin\svnlook.exe"

%SVNLOOK% propget --revprop -r %REV% %REPOS% %PROPNAME% > %TEMP%\newrevprop.tmp
diff -u %TEMP%\oldrevprop.tmp %TEMP%\newrevprop.tmp | sed -e "s/^---.*$/--- old property value/" -e "s/^+++.*$/+++ new property value/" -e "/^\\.*$/d" > %TEMP%\revprop.diff  

%TOOLS_DIR%\commit-email.pl --revprop-change -d %TEMP%\revprop.diff %REPOS% %REV% %USER% %PROPNAME% -h %HOSTNAME% -s %PROJECT% %EMAIL%

DEL %TEMP%\oldrevprop.tmp
DEL %TEMP%\newrevprop.tmp
DEL %TEMP%\revprop.diff

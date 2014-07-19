@ECHO OFF
REM PRE-REVPROP-CHANGE HOOK
REM
REM The pre-revprop-change hook is invoked before a revision property
REM is added, modified or deleted.  Subversion runs this hook by invoking
REM a program (script, executable, binary, etc.) named 'pre-revprop-change'
REM (for which this file is a template), with the following ordered
REM arguments:
REM
REM   [1] REPOS-PATH   (the path to this repository)
REM   [2] REVISION     (the revision being tweaked)
REM   [3] USER         (the username of the person tweaking the property)
REM   [4] PROPNAME     (the property being set on the revision)
REM   [5] ACTION       (the property is being 'A'dded, 'M'odified, or 'D'eleted)
REM
REM   [STDIN] PROPVAL  ** the new property value is passed via STDIN.
REM
REM If the hook program exits with success, the propchange happens; but
REM if it exits with failure (non-zero), the propchange doesn't happen.
REM The hook program can use the 'svnlook' utility to examine the
REM existing value of the revision property.
REM
REM WARNING: unlike other hooks, this hook MUST exist for revision
REM properties to be changed.  If the hook does not exist, Subversion
REM will behave as if the hook were present, but failed.  The reason
REM for this is that revision properties are UNVERSIONED, meaning that
REM a successful propchange is destructive;  the old value is gone
REM forever.  We recommend the hook back up the old value somewhere.
REM
REM On a Unix system, the normal procedure is to have 'pre-revprop-change'
REM invoke other programs to do the real work, though it may do the
REM work itself too.
REM
REM Note that 'pre-revprop-change' must be executable by the user(s) who will
REM invoke it (typically the user httpd runs as), and that user must
REM have filesystem-level permission to access the repository.
REM
REM On a Windows system, you should name the hook program
REM 'pre-revprop-change.bat' or 'pre-revprop-change.exe',
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

SET SVN_DIR=C:\Program Files\Subversion

SET SVNLOOK="%SVN_DIR%\bin\svnlook.exe"

if not "%PROPNAME%" == "svn:log" goto error
%SVNLOOK% propget --revprop -r %REV% %REPOS% %PROPNAME% > %TEMP%\oldrevprop.tmp
goto end

:error
echo Changing revision properties other than svn:log is prohibited >&2

:end

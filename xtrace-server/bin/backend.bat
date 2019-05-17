@REM ----------------------------------------------------------------------------
@REM  Copyright 2001-2006 The Apache Software Foundation.
@REM
@REM  Licensed under the Apache License, Version 2.0 (the "License");
@REM  you may not use this file except in compliance with the License.
@REM  You may obtain a copy of the License at
@REM
@REM       http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.
@REM ----------------------------------------------------------------------------
@REM
@REM   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
@REM   reserved.

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\commons-codec\commons-codec\1.4\commons-codec-1.4.jar;"%REPO%"\com\google\guava\guava\19.0\guava-19.0.jar;"%REPO%"\com\typesafe\config\1.2.1\config-1.2.1.jar;"%REPO%"\com\google\protobuf\protobuf-java\2.5.0\protobuf-java-2.5.0.jar;"%REPO%"\log4j\log4j\1.2.14\log4j-1.2.14.jar;"%REPO%"\net\minidev\json-smart\2.2\json-smart-2.2.jar;"%REPO%"\net\minidev\accessors-smart\1.1\accessors-smart-1.1.jar;"%REPO%"\org\ow2\asm\asm\5.0.3\asm-5.0.3.jar;"%REPO%"\velocity\velocity\1.5\velocity-1.5.jar;"%REPO%"\commons-collections\commons-collections\3.1\commons-collections-3.1.jar;"%REPO%"\commons-lang\commons-lang\2.1\commons-lang-2.1.jar;"%REPO%"\oro\oro\2.0.8\oro-2.0.8.jar;"%REPO%"\org\mortbay\jetty\jetty\6.0.2\jetty-6.0.2.jar;"%REPO%"\org\mortbay\jetty\servlet-api-2.5\6.0.2\servlet-api-2.5-6.0.2.jar;"%REPO%"\org\mortbay\jetty\jetty-util\6.0.2\jetty-util-6.0.2.jar;"%REPO%"\javax\servlet\servlet-api\2.4\servlet-api-2.4.jar;"%REPO%"\org\slf4j\slf4j-api\1.5.8\slf4j-api-1.5.8.jar;"%REPO%"\org\slf4j\slf4j-log4j12\1.5.8\slf4j-log4j12-1.5.8.jar;"%REPO%"\org\apache\derby\derby\10.9.1.0\derby-10.9.1.0.jar;"%REPO%"\edu\brown\cs\systems\pubsub\4.0\pubsub-4.0.jar;"%REPO%"\org\apache\commons\commons-lang3\3.4\commons-lang3-3.4.jar;"%REPO%"\com\beust\jcommander\1.48\jcommander-1.48.jar;"%REPO%"\io\netty\netty-all\4.0.29.Final\netty-all-4.0.29.Final.jar;"%REPO%"\org\javassist\javassist\3.18.1-GA\javassist-3.18.1-GA.jar;"%REPO%"\com\github\davidmoten\flatbuffers-java\1.3.0.1\flatbuffers-java-1.3.0.1.jar;"%REPO%"\edu\brown\cs\systems\xtrace-common\4.0\xtrace-common-4.0.jar;"%REPO%"\edu\brown\cs\systems\tracingplane-common\4.0\tracingplane-common-4.0.jar;"%REPO%"\edu\brown\cs\systems\xtrace-visualization\4.0\xtrace-visualization-4.0.jar;"%REPO%"\edu\brown\cs\systems\xtrace-server\4.0\xtrace-server-4.0.jar

set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% -Xmx1000m -Dlog4j.configuration=log4j-xtrace.properties -Dpubsub.client.printStatsInterval=10000 -Dpubsub.client.subscriberThreads=4 -classpath %CLASSPATH% -Dapp.name="backend" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" edu.brown.cs.systems.xtrace.server.XTraceServer %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%

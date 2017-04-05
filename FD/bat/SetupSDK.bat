:: Set working dir
cd %~dp0 & cd ..

:user_configuration

call .\..\..\..\SDK.bat
:: remove the above line and set the SDK paths directly like below
::set FLEX_SDK=D:\flex_sdk_4.6_air_sdk_24-beta
::set ANDROID_SDK=D:\android

set AUTO_INSTALL_IOS=yes

:validation
if not exist "%FLEX_SDK%\bin" goto flexsdk
if not exist "%ANDROID_SDK%\platform-tools" goto androidsdk
goto succeed

:flexsdk
echo.
echo ERROR: incorrect path to Flex SDK in 'bat\SetupSDK.bat'
echo.
echo Looking for: %FLEX_SDK%\bin
echo.
if %PAUSE_ERRORS%==1 pause
exit

:androidsdk
echo.
echo ERROR: incorrect path to Android SDK in 'bat\SetupSDK.bat'
echo.
echo Looking for: %ANDROID_SDK%\platform-tools
echo.
if %PAUSE_ERRORS%==1 pause
exit

:succeed
set PATH=%FLEX_SDK%\bin;%PATH%
set PATH=%PATH%;%ANDROID_SDK%\platform-tools

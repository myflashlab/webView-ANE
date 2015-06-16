:user_configuration

:: About AIR application packaging
:: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959
:: http://livedocs.adobe.com/flex/3/html/distributing_apps_4.html#1037515

:: NOTICE: all paths are relative to project root

:: Android packaging
set AND_CERT_NAME="exWebView"
set AND_CERT_PASS=fd
set AND_CERT_FILE=cert\exWebView.p12
set AND_ICONS=icons/android

set AND_SIGNING_OPTIONS=-storetype pkcs12 -keystore "%AND_CERT_FILE%" -storepass %AND_CERT_PASS%

:: iOS packaging
set IOS_DIST_CERT_FILE=cert\CertificatesDistribute.p12
set IOS_DEV_CERT_FILE=cert\certificate_dev.p12
set IOS_DEV_CERT_PASS=pass
set IOS_PROVISION_DEV=cert\comDoitflash.mobileprovision
set IOS_PROVISION_DIST=cert\adHoc_exAR.mobileprovision
set IOS_PROVISION_ADHOC=cert\adHoc_exAR.mobileprovision
set IOS_ICONS=icons/ios

set IOS_DEV_SIGNING_OPTIONS=-hideAneLibSymbols yes -storetype pkcs12 -keystore "%IOS_DEV_CERT_FILE%" -storepass %IOS_DEV_CERT_PASS% -provisioning-profile %IOS_PROVISION_DEV%
set IOS_DIST_SIGNING_OPTIONS=-hideAneLibSymbols yes -useLegacyAOT yes -storetype pkcs12 -keystore "%IOS_DIST_CERT_FILE%" -provisioning-profile %IOS_PROVISION_DIST%
set IOS_ADHOC_SIGNING_OPTIONS=-hideAneLibSymbols yes -useLegacyAOT yes -storetype pkcs12 -keystore "%IOS_DIST_CERT_FILE%" -provisioning-profile %IOS_PROVISION_ADHOC%

:: Application descriptor
set APP_XML=application.xml

:: Files to package
set APP_DIR=bin
set FILE_OR_DIR=-C %APP_DIR% .

:: Your application ID (must match <id> of Application descriptor)
set APP_ID=com.doitflash.exWebView

:: Output packages
set DIST_PATH=dist
set DIST_NAME=exWebView

:: Debugging using a custom IP
set DEBUG_IP=192.168.0.12



:validation
%SystemRoot%\System32\find /C "<id>%APP_ID%</id>" "%APP_XML%" > NUL
if errorlevel 1 goto badid
goto end

:badid
echo.
echo ERROR: 
echo   Application ID in 'bat\SetupApplication.bat' (APP_ID) 
echo   does NOT match Application descriptor '%APP_XML%' (id)
echo.

:end
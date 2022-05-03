@echo off

set EXPLORER_VERSION=9.16.2


echo Fetching explorer %EXPLORER_VERSION% source
curl -L https://github.com/ergoplatform/explorer-backend/archive/refs/tags/%EXPLORER_VERSION%.tar.gz > explorer-backend-%EXPLORER_VERSION%.tar.gz || exit /b

echo Extracting explorer source
del /S /Q explorer-backend\%EXPLORER_VERSION%
tar -xf explorer-backend-%EXPLORER_VERSION%.tar.gz  || exit /b
del /S /Q explorer-backend-%EXPLORER_VERSION%.tar.gz  || exit /b

echo Preparing grabber Dockerfile
copy explorer-backend-%EXPLORER_VERSION%\modules\chain-grabber\Dockerfile explorer-backend-%EXPLORER_VERSION%\chain-grabber.Dockerfile || exit /b

echo Preparing api Dockerfile
copy explorer-backend-%EXPLORER_VERSION%\modules\explorer-api\Dockerfile explorer-backend-%EXPLORER_VERSION%\explorer-api.Dockerfile || exit /b

echo Done.

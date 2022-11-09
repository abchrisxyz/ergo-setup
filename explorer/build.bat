@echo off

set EXPLORER_VERSION=9.17.4


echo Fetching explorer %EXPLORER_VERSION% source
curl -L https://github.com/ergoplatform/explorer-backend/archive/refs/tags/%EXPLORER_VERSION%.tar.gz > explorer-backend-%EXPLORER_VERSION%.tar.gz || exit /b

echo Extracting explorer source
del /S /Q explorer-backend\%EXPLORER_VERSION%
tar -xf explorer-backend-%EXPLORER_VERSION%.tar.gz  || exit /b
del /S /Q explorer-backend-%EXPLORER_VERSION%.tar.gz  || exit /b

echo Preparing Dockerfiles
copy explorer-backend-%EXPLORER_VERSION%\modules\chain-grabber\Dockerfile explorer-backend-%EXPLORER_VERSION%\chain-grabber.Dockerfile || exit /b
copy explorer-backend-%EXPLORER_VERSION%\modules\explorer-api\Dockerfile explorer-backend-%EXPLORER_VERSION%\explorer-api.Dockerfile || exit /b
copy explorer-backend-%EXPLORER_VERSION%\modules\utx-broadcaster\Dockerfile explorer-backend-%EXPLORER_VERSION%\utx-broadcaster.Dockerfile || exit /b
copy explorer-backend-%EXPLORER_VERSION%\modules\utx-tracker\Dockerfile explorer-backend-%EXPLORER_VERSION%\utx-tracker.Dockerfile || exit /b

echo Done.

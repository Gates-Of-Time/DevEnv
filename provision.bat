@echo off

trap "cleanup" "EXIT"
trap "cntr_c" "SIGINT"
CALL :cleanup
docker-compose "run" "--name" "provision" "--entrypoint" "\home\eqemu\provision.sh" "shared_memory"
docker-compose "run" "shared_memory"

git clone git@github.com:Gates-Of-Time/FVProject-Quests.git quests

EXIT /B %ERRORLEVEL%

:cleanup
docker-compose "stop"
docker "rm" "--force" "provision"
EXIT /B 0

:cntr_c
CALL :cleanup
exit
EXIT /B 0

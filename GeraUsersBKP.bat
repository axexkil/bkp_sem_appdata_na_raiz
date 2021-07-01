@echo off
cls
echo *** Listagem dos usuarios da Estacao Antiga ***
echo.
set /p IP="Insira o IP da Estacao Antiga: "
echo.
dir \\%IP%\c$\Users /b>Users.lst
echo Arquivo Users.lst Gerado
echo.
type Users.lst
echo.
echo Favor Abrir o arquivo Users.lst e eliminar os Usuarios Desnecessarios ao Backup.
echo.
pause
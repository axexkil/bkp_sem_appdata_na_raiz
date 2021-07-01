@echo off
chcp 65001
cls
echo *** Listagem dos usuarios da Estacao Antiga ***
echo.
set /p IP="Insira o IP da Estacao Antiga: "
echo.
dir \a :-h \\%IP%\c$ /b>pastas.txt
echo Arquivo pastas.txt Gerado
echo.
type pastas.txt
echo.
echo Favor Abrir o arquivo pastas.txt e eliminar as pastas Desnecessarios ao Backup.
echo.
chcp 850
pause
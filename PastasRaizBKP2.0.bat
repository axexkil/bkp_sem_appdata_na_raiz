@echo off
setlocal enableextensions enabledelayedexpansion
cls

echo.
for /f %%i in ("Pastas.txt") do set size=%%~zi
if "%size%" EQU "0" (
	echo. 
	echo Arquivo Pastas.txt NAO EXISTE ou VAZIO
	echo.
	echo Editar Pastas.txt
	goto :FIM
)

echo. 
set /p IP="Insira IP: "
set CNX=0
echo.

:LOOP
echo INSERIR UMA LETRA DE UNIDADE QUE JA NÃO ESTEJA EM USO
set/p LTR=LETRA:
if not exist %LTR%:\ (
	net use %LTR%: \\%IP%\c$
	goto :OK
	) else ( 
	@echo. 
	@echo LETRA JA EM USO
	@echo.
	goto :LOOP
)
:OK

chcp 65001
for /f "delims=*" %%s in (Pastas.txt) do (
	echo Inicio Backup    %date:~0,2%-%date:~3,2%-%date:~-4% %time:~0,2%:%time:~3,2%:%time:~6,2%>Backup_PASTAS.log
	rar.exe a -r -m1 -ma4 -x*\~$* -x*\AppData -x*\"Ambiente de impressão" -x*\"Ambiente de rede" -x*\"Configurações locais" -x*\"Dados de Aplicativos" "c:\BACKUP_DOCUMENTOS\%%s.7z" "%LTR%:\%%s"
)
TASKKILL /F /IM LPD.exe
timeout /t 10 /nobreak

for /f "delims=*" %%s in (Pastas.txt) do (
	rar.exe x -y "c:\BACKUP_DOCUMENTOS\%%s.7z" "c:\"
)
echo FIM    Backup    %date:~0,2%-%date:~3,2%-%date:~-4% %time:~0,2%:%time:~3,2%:%time:~6,2%>>Backup_PASTAS.log
	
:FIM
chcp 850
echo " _______ _____ _______      ______  _     _  _____        ______ _______ _____ ______"
echo " |______   |   |  |  |      |_____] |____/  |_____]      |_____/ |_____|   |    ____/"
echo " |       __|__ |  |  |      |_____] |    \_ |            |    \_ |     | __|__ /_____"
echo "                                                                                     " 
echo "    _ ____ ____ ____   _  _ _ ___ ____ ____   ____ ____ ____ _  _ ____";
echo " ___| [__] |--| [__]    \/  |  |  [__] |--<   |--< [__] |___ |--| |--|";                                                                               
pause

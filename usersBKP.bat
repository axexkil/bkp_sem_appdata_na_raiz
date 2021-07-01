@echo off
setlocal enableextensions enabledelayedexpansion
cls

set ZIP=rar.exe

@echo. 
set /p IP="Insira IP: "
set CNX=0
@echo.
:LOOP
echo INSERIR UMA LETRA DE UNIDADE QUE JA NÃO ESTEJA EM USO
set/p LTR=LETRA:

if not exist %LTR%:\ (
	net use %LTR%: \\%IP%\c$\users 
	goto :OK
	) else ( 
	@echo. 
	@echo LETRA JA EM USO
	@echo.
	goto :LOOP
)
:OK

set /p NomeTecnico="Insira Nome Responsavel pelo Backup :"
echo.
set /p PTM="Insira Patrimonio Antigo: "

echo %NomeTecnico%>Backup_%PTM%.log

ping -n 1 %IP% > nul

if "%errorlevel%" EQU "0" (
	type nul > vazio
	@fc users.lst vazio > nul
	if "%errorlevel%" EQU "0" (
		echo Inicio Backup    %date:~0,2%-%date:~3,2%-%date:~-4% %time:~0,2%:%time:~3,2%:%time:~6,2%>>Backup_%PTM%.log
		for /f "tokens=1" %%s in (users.lst) do (
			%ZIP% a -r -ma4 -x*\~* -x%%s\AppData -ilog.\Erro_BKP-%%s.log -m1 c:\BACKUP_DOCUMENTOS\%%s.7z %LTR%:\%%s
			del Erro_BKP%%s.log >nul 2>&1
			if exist Erro_BKP-%%s.log (
				timeout /t 60 /nobreak
				%ZIP% u -r -ma4 -x*\~* -x%%s\AppData -m1 c:\BACKUP_DOCUMENTOS\%%s.7z
			echo Bkp Arq Abertos %date:~0,2%-%date:~3,2%-%date:~-4% %time:~0,2%:%time:~3,2%:%time:~6,2%>>Backup_%PTM%.log
			)
		)
		for /f "tokens=1" %%s in (users.lst) do (
			%ZIP% x c:\BACKUP_DOCUMENTOS\%%s.7z c:\BACKUP_DOCUMENTOS\
		)
	
	) else (
		@echo. 
		echo MAQUINA DESLIGADA
	)
) else (
	@echo. 
	@echo Arquivo users.txt NAO EXISTE ou VAZIO
	@echo.
	@echo Executar userTXT.bat
	net use %LTR%: /DELETE
)

pause 
echo Executando Backup de Windows Mail acima de 15 MB
echo . 
for /f %%s in (users.lst) do (
	sfk list -juststat -gbytes "%LTR%:\%%s\AppData\Local\Microsoft\Windows Mail" +head -lines=1 +filt -sep "," -format "$col4" +filt -sep " " -format "$col2" +calc "#text/1048576" -dig=2 +filt -format "$col1" +tofile SIZE.TMP
	set /P SIZEM=<SIZE.TMP
	timeout /t 1 > nul
	echo !SIZEM!
	if !SIZEM! GTR 15.00 (
	rar.exe a -r -ma4 c:\BACKUP_DOCUMENTOS\Windows_Mail_%%s.7z "%LTR%:\%%s\AppData\Local\Microsoft\Windows Mail" 
	)
)

echo Fim      Backup  %date:~0,2%-%date:~3,2%-%date:~-4% %time:~0,2%:%time:~3,2%:%time:~6,2%>>Backup_%PTM%.log
@echo. 
net use %LTR%: /DELETE
pause

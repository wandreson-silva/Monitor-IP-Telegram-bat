@echo off
title Monitor de IP com Telegram
setlocal enabledelayedexpansion

:: ===== CONFIGURACOES =====
set TOKEN=DIGITE SEU TOKEN AQUI
set CHAT_ID=DIGITE SEU ID AQUI
set FILE_IP=ip_atual.txt
set INTERVALO=60
:: ===========================

:LOOP

:: Obtendo IP publico
for /f "delims=" %%i in ('powershell -Command "(Invoke-RestMethod -Uri 'https://api.ipify.org')"') do set IP_ATUAL=%%i

if not exist %FILE_IP% (
    echo %IP_ATUAL% > %FILE_IP%
    echo IP inicial detectado: %IP_ATUAL%
    goto WAIT
)

set /p IP_ANTIGO=<%FILE_IP%

if not "%IP_ATUAL%"=="%IP_ANTIGO%" (
    echo.
    echo MUDANCA DE IP DETECTADA!
    echo Antigo: %IP_ANTIGO%
    echo Novo:   %IP_ATUAL%

    echo %IP_ATUAL% > %FILE_IP%

    powershell -Command ^
    "$msg='🔔 IP alterado!`nAntigo: %IP_ANTIGO%`nNovo: %IP_ATUAL%';" ^
    "Invoke-RestMethod -Uri 'https://api.telegram.org/bot%TOKEN%/sendMessage' -Method Post -Body @{chat_id='%CHAT_ID%';text=$msg}"
)

:WAIT
timeout /t %INTERVALO% /nobreak > nul
goto LOOP
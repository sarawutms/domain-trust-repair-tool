@echo off
:: รีบเช็คสิทธิ์และเทสีแดงทันทีเพื่อลดอาการแวบสีดำ
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 4F
    goto :AccessDenied
)

:: =========================================================
:: MAIN SCRIPT (ทำงานเมื่อมีสิทธิ์ Admin)
:: =========================================================
color 07
title Domain Trust Relationship Repair Tool
cls
echo ===================================================
echo     Domain Trust Relationship Repair Tool
echo ===================================================
echo.

:: ---------------------------------------------------------
set "MY_DOMAIN=YOUR_DOMAIN.com"
set "MY_USER=YOUR_ADMIN_USER"
set "MY_PASS=YOUR_PASSWORD"
:: ---------------------------------------------------------

set "FULL_ACCOUNT=%MY_DOMAIN%\%MY_USER%"

echo [*] Target Admin User: %FULL_ACCOUNT%
echo [*] Processing Credentials automatically...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$user = '%FULL_ACCOUNT%'; $plainPass = '%MY_PASS%'; $secPass = ConvertTo-SecureString $plainPass -AsPlainText -Force; $cred = New-Object System.Management.Automation.PSCredential ($user, $secPass); Write-Host ''; Write-Host '[*] Repairing Trust Relationship... Please wait.' -ForegroundColor Cyan; Write-Host '[' -NoNewline -ForegroundColor White; for($i=1; $i-le 40; $i++){ Write-Host '=' -NoNewline -ForegroundColor Yellow; Start-Sleep -Milliseconds 10 }; Write-Host '] 100%%' -ForegroundColor White; Write-Host ''; Write-Host ''; $result = $false; for($attempt=1; $attempt -le 3; $attempt++){ $result = Test-ComputerSecureChannel -Repair -Server '%MY_DOMAIN%' -Credential $cred; if($result -eq $true){ break } else { Start-Sleep -Seconds 2 } }; Add-Type -AssemblyName System.Windows.Forms; if($result -eq $true){ Write-Host '----------------------------------------' -ForegroundColor Green; Write-Host '  RESULT: TRUE (SUCCESS)' -ForegroundColor Green; Write-Host '----------------------------------------' -ForegroundColor Green; Write-Host 'The trust relationship has been fixed successfully!' -ForegroundColor Green; Write-Host 'You can Sign out and Login with Domain Account now.' -ForegroundColor White; Write-Host ''; $msg = 'SUCCESS' + [Environment]::NewLine + 'You can Sign out and Login with Domain Account now.'; $null = [System.Windows.Forms.MessageBox]::Show($msg, 'SUCCESS', 'OK', 'Information'); }else{ Write-Host '----------------------------------------' -ForegroundColor Red; Write-Host '  RESULT: FALSE (FAILED)' -ForegroundColor Red; Write-Host '----------------------------------------' -ForegroundColor Red; Write-Host 'Could not repair the trust. Please check Network or Credentials.' -ForegroundColor Red; Write-Host ''; $msgFail = 'FAILED' + [Environment]::NewLine + 'Could not repair the trust. Please check Network or Credentials.'; $null = [System.Windows.Forms.MessageBox]::Show($msgFail, 'FAILED', 'OK', 'Error'); }; $delMsg = 'Do you want to delete this script?'; $delChoice = [System.Windows.Forms.MessageBox]::Show($delMsg, 'Delete Tool?', 'YesNo', 'Question'); if($delChoice -eq 'Yes'){ exit 0 } else { exit 99 }"

:: ตรวจสอบรหัสที่ได้จากการกด Yes (0) หรือ No (99)
if %errorlevel% equ 0 (
    :: สั่งให้ Command Prompt แยกตัวออกไปลบไฟล์ .bat นี้ทิ้ง (%~f0) แล้วปิดตัวเองทันที
    start /b "" cmd /c del "%~f0" & exit
) else (
    exit /b
)

:: =========================================================
:: ACCESS DENIED SCREEN (หน้าจอกระพริบแบบคำนวณกึ่งกลางหน้าจอ)
:: =========================================================
:AccessDenied
cls
title ACCESS DENIED - Administrator Required

:: 1. สร้างไฟล์ Lock และ VBScript สำหรับ Popup
set "LOCKFILE=%temp%\admin_popup.tmp"
set "VBSFILE=%temp%\admin_popup.vbs"
echo. > "%LOCKFILE%"
echo MsgBox "Please Right-click this file and select 'Run as administrator.'", 16, "Administrator Required" > "%VBSFILE%"
echo CreateObject("Scripting.FileSystemObject").DeleteFile("%LOCKFILE%") >> "%VBSFILE%"

:: 2. เรียก Popup ทำงานเบื้องหลัง
start "" wscript.exe "%VBSFILE%"

:: 3. ใช้ PowerShell สร้างลูปกระพริบ + จัดกึ่งกลางอัตโนมัติ 
powershell -NoProfile -ExecutionPolicy Bypass -Command "$l='%temp%\admin_popup.tmp'; $m1='ACCESS DENIED'; $m2='ERROR: Administrator privileges are required!'; $m3='Please Right-click on this file and select:'; $m4='\"Run as administrator\"'; while(Test-Path $l){ try{ $w=[Console]::WindowWidth; $h=[Console]::WindowHeight; $y=[math]::Max(0,[math]::Floor($h/2)-3); [Console]::BackgroundColor='DarkRed'; [Console]::ForegroundColor='White'; [Console]::Clear(); [Console]::SetCursorPosition([math]::Max(0,($w-$m1.Length)/2),$y); Write-Host $m1; [Console]::SetCursorPosition([math]::Max(0,($w-$m2.Length)/2),$y+2); Write-Host $m2; [Console]::SetCursorPosition([math]::Max(0,($w-$m3.Length)/2),$y+4); Write-Host $m3; [Console]::SetCursorPosition([math]::Max(0,($w-$m4.Length)/2),$y+5); Write-Host $m4; Start-Sleep -Milliseconds 200; if(!(Test-Path $l)){break}; [Console]::BackgroundColor='Black'; [Console]::ForegroundColor='Red'; [Console]::Clear(); [Console]::SetCursorPosition([math]::Max(0,($w-$m1.Length)/2),$y); Write-Host $m1; [Console]::SetCursorPosition([math]::Max(0,($w-$m2.Length)/2),$y+2); Write-Host $m2; [Console]::SetCursorPosition([math]::Max(0,($w-$m3.Length)/2),$y+4); Write-Host $m3; [Console]::SetCursorPosition([math]::Max(0,($w-$m4.Length)/2),$y+5); Write-Host $m4; Start-Sleep -Milliseconds 200; }catch{ Start-Sleep -Milliseconds 200 } }; [Console]::BackgroundColor='Black'; [Console]::Clear();"

:: ทำความสะอาดไฟล์ขยะและปิดตัวเอง
del "%VBSFILE%" 2>nul
exit /b
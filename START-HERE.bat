@echo off
chcp 65001 >nul
cls
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║     🚀 SEB PROXY MITM - FLY.IO DEPLOYMENT                ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo.
echo ┌───────────────────────────────────────────────────────────┐
echo │  BƯỚC 1: PUSH LÊN GITHUB                                  │
echo └───────────────────────────────────────────────────────────┘
echo.
echo   Chuẩn bị:
echo   1. Tạo repository trên GitHub: https://github.com/new
echo      - Name: seb-proxy-flyio
echo      - Visibility: Public hoặc Private
echo      - KHÔNG tick "Add a README file"
echo.
echo   2. Copy URL repository (ví dụ):
echo      https://github.com/username/seb-proxy-flyio.git
echo.
echo.
pause
echo.
echo Bắt đầu push...
echo.
call PUSH-TO-GITHUB.bat

if %errorLevel% equ 0 (
    echo.
    echo ┌───────────────────────────────────────────────────────────┐
    echo │  BƯỚC 2: DEPLOY LÊN FLY.IO                                │
    echo └───────────────────────────────────────────────────────────┘
    echo.
    echo   Cài Fly CLI (PowerShell, quyền Admin^):
    echo.
    echo   irm https://fly.io/install.ps1 ^| iex
    echo.
    echo   Sau khi cài:
    echo   1. Đóng PowerShell và mở lại
    echo   2. flyctl auth login
    echo   3. flyctl launch
    echo.
    echo   Chi tiết: Đọc file DEPLOY.md
    echo.
    echo ┌───────────────────────────────────────────────────────────┐
    echo │  ✅ CODE ĐÃ PUSH LÊN GITHUB THÀNH CÔNG!                  │
    echo └───────────────────────────────────────────────────────────┘
    echo.
) else (
    echo.
    echo ┌───────────────────────────────────────────────────────────┐
    echo │  ❌ PUSH THẤT BẠI                                         │
    echo └───────────────────────────────────────────────────────────┘
    echo.
    echo Kiểm tra lại:
    echo   - GitHub repository đã tạo chưa?
    echo   - Username/token đúng chưa?
    echo   - Internet kết nối chưa?
    echo.
)

pause


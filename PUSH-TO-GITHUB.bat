@echo off
chcp 65001 >nul
echo.
echo ============================================
echo   PUSH CODE LÊN GITHUB
echo ============================================
echo.

REM Kiểm tra git
where git >nul 2>nul
if %errorLevel% neq 0 (
    echo ❌ Git chưa cài!
    echo.
    echo Download: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo ✅ Git đã cài
echo.

REM Kiểm tra đã init git chưa
if not exist ".git" (
    echo [1/5] Init git repository...
    git init
    git branch -M main
    echo ✅ Git initialized
    echo.
) else (
    echo [1/5] Git repository đã tồn tại
    echo.
)

REM Thêm files
echo [2/5] Adding files...
git add .
echo ✅ Files added
echo.

REM Commit
echo [3/5] Committing...
set /p commit_msg="Nhập commit message (Enter để dùng mặc định): "
if "%commit_msg%"=="" set commit_msg=Update proxy code

git commit -m "%commit_msg%"
echo ✅ Committed: %commit_msg%
echo.

REM Kiểm tra remote
git remote get-url origin >nul 2>nul
if %errorLevel% neq 0 (
    echo [4/5] Chưa có GitHub remote!
    echo.
    echo ⚠️  Hướng dẫn:
    echo.
    echo 1. Tạo repository trên GitHub:
    echo    https://github.com/new
    echo.
    echo 2. Repository name: seb-proxy-flyio
    echo.
    echo 3. KHÔNG tick "Add a README"
    echo.
    echo 4. Copy URL repository (vd: https://github.com/username/seb-proxy-flyio.git^)
    echo.
    set /p repo_url="Nhập GitHub repository URL: "
    
    git remote add origin !repo_url!
    echo ✅ Remote added
    echo.
) else (
    echo [4/5] GitHub remote đã tồn tại
    echo.
)

REM Push
echo [5/5] Pushing to GitHub...
echo.
echo ⚠️  Nếu hỏi login:
echo    Username: your-github-username
echo    Password: Personal Access Token (KHÔNG phải password GitHub^)
echo    Tạo token: https://github.com/settings/tokens
echo.

git push -u origin main

if %errorLevel% equ 0 (
    echo.
    echo ============================================
    echo   ✅ PUSH THÀNH CÔNG!
    echo ============================================
    echo.
    echo Code đã được push lên GitHub!
    echo.
    echo Tiếp theo:
    echo   1. Cài Fly CLI: irm https://fly.io/install.ps1 ^| iex
    echo   2. Login: flyctl auth login
    echo   3. Deploy: flyctl launch
    echo.
    echo Chi tiết xem file: DEPLOY.md
    echo.
) else (
    echo.
    echo ❌ Push thất bại!
    echo.
    echo Kiểm tra:
    echo   - GitHub username/token đúng chưa?
    echo   - Repository đã tạo chưa?
    echo   - Internet kết nối chưa?
    echo.
)

pause


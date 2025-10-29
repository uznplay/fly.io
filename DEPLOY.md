# 🚀 HƯỚNG DẪN DEPLOY LÊN FLY.IO

## 📋 **CHUẨN BỊ:**

### **1. Tạo GitHub Repository:**

1. Truy cập: https://github.com/new
2. Repository name: `seb-proxy-flyio`
3. Visibility: **Public** (hoặc Private)
4. **KHÔNG** tick "Add a README file"
5. Click **"Create repository"**

---

### **2. Push code lên GitHub:**

**Mở PowerShell trong folder `seb-proxy-flyio`:**

```powershell
cd C:\Users\uznpl\Downloads\seb-win-refactoring-3.10.0\seb-proxy-flyio

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - SEB MITM Proxy"

# Add remote (THAY YOUR-USERNAME bằng username GitHub của bạn)
git remote add origin https://github.com/YOUR-USERNAME/seb-proxy-flyio.git

# Push
git push -u origin main
```

**Nếu lỗi "main branch doesn't exist":**
```powershell
git branch -M main
git push -u origin main
```

**Nếu hỏi login:**
- Username: `your-github-username`
- Password: **Personal Access Token** (KHÔNG phải password GitHub)
  - Tạo token: https://github.com/settings/tokens
  - Scopes: `repo`

---

## ✈️ **DEPLOY LÊN FLY.IO:**

### **BƯỚC 1: Cài Fly CLI**

**Trên Windows (PowerShell):**

```powershell
# Cài qua installer
irm https://fly.io/install.ps1 | iex
```

**Sau khi cài, ĐÓNG PowerShell và mở lại để load PATH.**

**Kiểm tra:**
```powershell
flyctl version
```

---

### **BƯỚC 2: Đăng ký Fly.io**

```powershell
flyctl auth signup
```

**Hoặc nếu đã có account:**
```powershell
flyctl auth login
```

**Trình duyệt sẽ mở:**
1. Đăng ký bằng **Email** hoặc **GitHub**
2. Xác thực email
3. **Add credit card** (bắt buộc, nhưng không charge nếu dưới quota)
   - Chọn: **"Hobby plan"** (Free)
   - Nhập thông tin thẻ
   - ✅ **Set spending limit = $0** (để không bị charge)

---

### **BƯỚC 3: Clone repository (nếu chưa có local)**

```powershell
cd C:\Users\uznpl\Downloads
git clone https://github.com/YOUR-USERNAME/seb-proxy-flyio.git
cd seb-proxy-flyio
```

**Hoặc nếu đã có local, chỉ cần cd vào:**
```powershell
cd C:\Users\uznpl\Downloads\seb-win-refactoring-3.10.0\seb-proxy-flyio
```

---

### **BƯỚC 4: Deploy lần đầu**

```powershell
flyctl launch
```

**Sẽ hỏi các câu:**

```
? Choose an app name (leave blank to generate one): 
→ Nhập: seb-proxy-mitm (hoặc để trống cho tự động)

? Choose a region for deployment: 
→ Chọn: sin (Singapore) - Gần VN nhất
   (Dùng mũi tên ↑↓ để chọn, Enter để confirm)

? Would you like to set up a Postgresql database now? 
→ No

? Would you like to set up an Upstash Redis database now? 
→ No

? Create .dockerignore from 1 .gitignore files? 
→ No (vì đã có .dockerignore)

? Would you like to deploy now? 
→ Yes
```

**Đợi 2-3 phút...**

---

### **BƯỚC 5: Kiểm tra deployment**

**Sau khi deploy xong, sẽ thấy:**
```
✅ Deployed successfully!
Your app is available at: https://seb-proxy-mitm.fly.dev
```

**Kiểm tra:**
```powershell
flyctl status
```

**Xem logs:**
```powershell
flyctl logs
```

**Test:**
```powershell
curl https://seb-proxy-mitm.fly.dev/
```

---

### **BƯỚC 6: Download Certificate**

**Download cert:**
```powershell
curl https://seb-proxy-mitm.fly.dev/cert -o seb-ca-cert.pem
```

**Hoặc mở trình duyệt:**
```
https://seb-proxy-mitm.fly.dev/cert
```

**Cài đặt certificate:**
1. Double-click file `seb-ca-cert.pem`
2. Click **"Install Certificate..."**
3. Chọn **"Local Machine"** → Next
4. Chọn **"Place all certificates in the following store"**
5. Click **"Browse"** → Chọn **"Trusted Root Certification Authorities"**
6. Click **OK** → Next → Finish
7. Click **"Yes"** khi hỏi Security Warning

---

### **BƯỚC 7: Test Proxy**

**Test HTTP:**
```powershell
curl -x http://seb-proxy-mitm.fly.dev:8080 http://httpbin.org/headers
```

**Test HTTPS:**
```powershell
curl -x http://seb-proxy-mitm.fly.dev:8080 https://httpbin.org/headers
```

**Kiểm tra log:**
```powershell
flyctl logs
```

**Phải thấy:**
```
✓ Header injected: X-SafeExamBrowser-ConfigKeyHash
✓ Header injected: X-SafeExamBrowser-RequestHash
```

---

### **BƯỚC 8: Config SEB**

**Mở SEB Config Tool:**

**Network → Proxy Settings:**
```
Proxy Settings Policy: Use Custom Settings

☑ Enable HTTP Proxy
HTTP Proxy Host: seb-proxy-mitm.fly.dev
HTTP Port: 8080

☑ Enable HTTPS Proxy  
HTTPS Proxy Host: seb-proxy-mitm.fly.dev
HTTPS Port: 8080
```

**Save config → Test SEB!**

---

## 🔄 **UPDATE CODE:**

### **Sau khi sửa code:**

```powershell
cd C:\Users\uznpl\Downloads\seb-win-refactoring-3.10.0\seb-proxy-flyio

# Add changes
git add .

# Commit
git commit -m "Update proxy code"

# Push to GitHub
git push

# Deploy to Fly.io
flyctl deploy
```

---

## 🔧 **QUẢN LÝ:**

### **Xem logs real-time:**
```powershell
flyctl logs -f
```

### **Xem status:**
```powershell
flyctl status
```

### **SSH vào container:**
```powershell
flyctl ssh console
```

### **Restart app:**
```powershell
flyctl apps restart seb-proxy-mitm
```

### **Xem dashboard web:**
```powershell
flyctl dashboard
```

---

## 💰 **SET SPENDING LIMIT (QUAN TRỌNG!):**

**Để không bị charge vượt free tier:**

```powershell
# Xem org hiện tại
flyctl orgs list

# Set limit = $0
flyctl orgs billing set-limit --org personal --limit 0
```

**Hoặc trên web:**
1. https://fly.io/dashboard/personal/billing
2. Set **Spending Limit: $0**

---

## 📊 **MONITOR USAGE:**

### **Xem usage:**
```powershell
flyctl orgs billing
```

### **Xem metrics:**
```
https://fly.io/dashboard/personal/apps/seb-proxy-mitm/metrics
```

---

## ⚠️ **TROUBLESHOOTING:**

### **Lỗi 1: "error connecting to Docker"**

```
Giải pháp:
  - Fly.io build Docker trên cloud, KHÔNG cần Docker local
  - Bỏ qua lỗi này, app vẫn deploy được
```

---

### **Lỗi 2: "No existing certificates detected"**

```
Giải pháp:
  - Fly.io tự động tạo HTTPS cert cho domain .fly.dev
  - Không ảnh hưởng proxy
```

---

### **Lỗi 3: "Health check failed"**

```
Giải pháp:
  flyctl logs
  
  Kiểm tra proxy có chạy không:
  flyctl ssh console
  ps aux | grep node
```

---

### **Lỗi 4: "ERR_CERT_AUTHORITY_INVALID" trong SEB**

```
Giải pháp:
  1. Download cert: https://seb-proxy-mitm.fly.dev/cert
  2. Cài lại vào Trusted Root
  3. Restart SEB
```

---

## 🎯 **CHECKLIST DEPLOY:**

- [ ] Code đã push lên GitHub
- [ ] Fly CLI đã cài
- [ ] Đã login Fly.io (`flyctl auth login`)
- [ ] Đã set spending limit = $0
- [ ] `flyctl launch` thành công
- [ ] App accessible: `https://seb-proxy-mitm.fly.dev`
- [ ] Download cert: `https://seb-proxy-mitm.fly.dev/cert`
- [ ] Cert đã cài vào Trusted Root
- [ ] Test proxy với curl
- [ ] Config SEB
- [ ] Test SEB với exam.fpt.edu.vn

---

## ✅ **XONG!**

```
✅ App: https://seb-proxy-mitm.fly.dev
✅ Certificate: https://seb-proxy-mitm.fly.dev/cert
✅ Proxy: seb-proxy-mitm.fly.dev:8080
✅ Free tier: $0/month
✅ Chạy 24/7
```

---

## 📞 **HỖ TRỢ:**

- **Fly.io Docs:** https://fly.io/docs/
- **Community:** https://community.fly.io/
- **Status:** https://status.flyio.net/

---

**Chúc bạn deploy thành công! 🚀**


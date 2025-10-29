# 🚀 Safe Exam Browser MITM Proxy - Fly.io Deployment

Forward proxy with HTTPS header injection for Safe Exam Browser.

## ✨ Features

- ✅ **HTTP/HTTPS Forward Proxy** with MITM support
- ✅ **Automatic header injection**:
  - `X-SafeExamBrowser-ConfigKeyHash`
  - `X-SafeExamBrowser-RequestHash`
- ✅ **Self-signed CA certificate** generation
- ✅ **Easy deployment** to Fly.io
- ✅ **Free tier compatible**

---

## 🚀 Quick Deploy to Fly.io

### **Prerequisites:**

- [Fly.io account](https://fly.io/app/sign-up) (free tier available)
- [Fly CLI](https://fly.io/docs/hands-on/install-flyctl/) installed
- Credit card for verification (won't be charged if under quota)

### **1. Clone this repository:**

```bash
git clone https://github.com/YOUR-USERNAME/seb-proxy-flyio.git
cd seb-proxy-flyio
```

### **2. Login to Fly.io:**

```bash
flyctl auth login
```

### **3. Deploy:**

```bash
flyctl launch

# Choose:
# - App name: seb-proxy-mitm (or your choice)
# - Region: sin (Singapore - closest to Vietnam)
# - Postgres: No
# - Redis: No
# - Deploy now: Yes
```

### **4. Wait for deployment (2-3 minutes)**

Your app will be available at:
```
https://seb-proxy-mitm.fly.dev
```

---

## 📥 Download Certificate

After deployment, download the CA certificate:

```bash
curl https://seb-proxy-mitm.fly.dev/cert -o seb-ca-cert.pem
```

Or visit in browser:
```
https://seb-proxy-mitm.fly.dev/cert
```

### **Install Certificate on Windows:**

1. Double-click `seb-ca-cert.pem`
2. Click **"Install Certificate..."**
3. Select **"Local Machine"** → Next
4. Select **"Place all certificates in the following store"**
5. Click **"Browse"** → Select **"Trusted Root Certification Authorities"**
6. Click **OK** → Next → Finish

---

## ⚙️ Configure Safe Exam Browser

In **SEB Config Tool**:

### **Network → Proxy Settings:**

```
Proxy Settings Policy: Use Custom Settings

HTTP Proxy:  seb-proxy-mitm.fly.dev
HTTP Port:   8080

HTTPS Proxy: seb-proxy-mitm.fly.dev
HTTPS Port:  8080

☑ Enable HTTPS Proxy
```

### **Save configuration** and test!

---

## 🔧 Configuration

### **Change injected headers:**

Edit `config.json`:

```json
{
  "headersToInject": {
    "X-SafeExamBrowser-ConfigKeyHash": "your-config-hash",
    "X-SafeExamBrowser-RequestHash": "your-request-hash"
  }
}
```

Then redeploy:
```bash
flyctl deploy
```

---

## 📊 Monitor & Manage

### **View logs:**
```bash
flyctl logs
```

### **Check status:**
```bash
flyctl status
```

### **SSH into container:**
```bash
flyctl ssh console
```

### **Restart app:**
```bash
flyctl apps restart seb-proxy-mitm
```

---

## 🆓 Free Tier Limits

Fly.io free tier includes:
- ✅ 3 shared-cpu VMs
- ✅ 3GB storage
- ✅ 160GB outbound traffic/month

**Your proxy should stay within free tier if used for SEB only.**

To avoid charges, set spending limit:
```bash
flyctl orgs billing set-limit --org personal --limit 0
```

---

## 🧪 Testing

### **Test HTTP:**
```bash
curl -x http://seb-proxy-mitm.fly.dev:8080 http://httpbin.org/headers
```

### **Test HTTPS:**
```bash
curl -x http://seb-proxy-mitm.fly.dev:8080 \
     --cacert seb-ca-cert.pem \
     https://httpbin.org/headers
```

You should see the injected headers in the response!

---

## 🔒 Security Note

**This is a Man-in-the-Middle proxy.** It intercepts and modifies HTTPS traffic.

- ⚠️ Only use for Safe Exam Browser testing/development
- ⚠️ Do NOT use for production or sensitive data
- ⚠️ Install CA certificate only on test machines

---

## 📝 How It Works

1. **Client** (SEB) → Sends request via proxy
2. **Proxy** → Intercepts HTTPS traffic using MITM
3. **Proxy** → Injects custom headers
4. **Proxy** → Forwards to destination server
5. **Server** → Receives request with injected headers

---

## 🛠️ Local Development

### **Install dependencies:**
```bash
npm install
```

### **Run locally:**
```bash
npm start
```

Proxy runs on: `http://localhost:8080`

### **Test locally:**
```bash
# HTTP test
curl -x http://localhost:8080 http://httpbin.org/headers

# HTTPS test (after installing local cert)
curl -x http://localhost:8080 --cacert certs/ca-cert.pem https://httpbin.org/headers
```

---

## 📚 Files Structure

```
seb-proxy-flyio/
├── proxy-mitm.js           # Main proxy server
├── index.js                # Entry point
├── setup-certificates.js   # Certificate generator
├── config.json             # Header configuration
├── package.json            # Dependencies
├── Dockerfile              # Docker config
├── fly.toml                # Fly.io config
├── .dockerignore
├── .gitignore
└── README.md
```

---

## ❓ Troubleshooting

### **Certificate errors in SEB:**

```
NET::ERR_CERT_AUTHORITY_INVALID
```

**Solution:** Ensure CA certificate is installed in **Trusted Root** store.

---

### **Proxy not accessible:**

```
ERR_CONNECTION_REFUSED
```

**Solution:** Check Fly.io app status:
```bash
flyctl status
flyctl logs
```

---

### **Headers not injected:**

**Solution:** Check logs to verify header injection:
```bash
flyctl logs
```

Look for: `✓ Header injected: X-SafeExamBrowser-ConfigKeyHash`

---

## 💰 Cost Estimate

With moderate use (< 1000 requests/day):
- **Free tier:** $0/month ✅
- **Low usage:** $0-3/month
- **High usage:** $5-10/month

**Recommendation:** Monitor usage in first month, set spending limit.

---

## 🤝 Support

- **Fly.io Docs:** https://fly.io/docs/
- **Fly.io Community:** https://community.fly.io/

---

## 📄 License

MIT License - Use at your own risk.

---

## 🎯 Quick Start Summary

```bash
# 1. Clone
git clone https://github.com/YOUR-USERNAME/seb-proxy-flyio.git
cd seb-proxy-flyio

# 2. Login
flyctl auth login

# 3. Deploy
flyctl launch

# 4. Get cert
curl https://seb-proxy-mitm.fly.dev/cert -o cert.pem

# 5. Install cert (Windows)
# Double-click cert.pem → Install → Trusted Root

# 6. Configure SEB
# Proxy: seb-proxy-mitm.fly.dev:8080

# 7. Done! 🎉
```

---

**Enjoy your MITM proxy! 🚀**


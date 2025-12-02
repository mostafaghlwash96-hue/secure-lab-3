# Quick Start Guide

## 🚀 Getting Started in 3 Steps

### Step 1: Install Dependencies & Generate Certificate
```bash
npm install
npm run generate-cert
```

### Step 2: Start the HTTPS Server
```bash
node server_https.js
```

### Step 3: Test in Browser
Open your browser and navigate to: **https://localhost:3443**

- You'll see a security warning (this is expected!)
- Click "Advanced" → "Proceed to localhost" to continue
- You should see: "🔐 Hello, this is a secure HTTPS server!"

## 📋 Complete File Structure

```
lab-3/
├── server.js              # HTTP server (starter code)
├── server_https.js        # HTTPS server (your solution)
├── generate-cert.js       # Certificate generation script
├── package.json           # Node.js dependencies
├── test-server.ps1       # Windows PowerShell test script
├── test-server.sh        # Linux/macOS test script
├── README.md             # Complete documentation
├── LAB_REPORT.md         # Lab report template
├── certs/
│   ├── server.key        # Private key
│   └── server.cert       # SSL certificate
└── node_modules/         # Dependencies (auto-generated)
```

## 🧪 Testing Commands

### Test HTTP Server (for comparison)
```bash
node server.js
# Visit: http://localhost:3000
```

### Test HTTPS Server
```bash
node server_https.js
# Visit: https://localhost:3443
```

### Test with Scripts
**Windows:**
```powershell
.\test-server.ps1
```

**Linux/macOS/WSL:**
```bash
chmod +x test-server.sh
./test-server.sh
```

## 📝 Next Steps for Lab Submission

1. ✅ Code files are ready
2. ✅ Certificate files are generated
3. ⏳ Take screenshots:
   - Certificate generation output
   - Browser warning page
   - Successful HTTPS connection
   - curl test results
4. ⏳ Record 30-60 second demo video
5. ⏳ Fill in your details in LAB_REPORT.md
6. ⏳ Submit all deliverables

## ❓ Troubleshooting

**Problem:** "Cannot find module 'selfsigned'"
- **Solution:** Run `npm install`

**Problem:** "ENOENT: no such file or directory, open './certs/server.key'"
- **Solution:** Run `npm run generate-cert` first

**Problem:** Browser shows "Connection refused"
- **Solution:** Make sure the server is running (`node server_https.js`)

**Problem:** PowerShell script doesn't work
- **Solution:** Make sure you're using PowerShell (not Command Prompt) and the server is running

## 📚 Additional Resources

- See `README.md` for detailed documentation
- See `LAB_REPORT.md` for complete lab report template
- Node.js HTTPS docs: https://nodejs.org/api/https.html


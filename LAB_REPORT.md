# Lab 3: Implementing SSL/TLS on a Node.js Server
## Lab Report

**Student Name:** [Your Name]  
**Date:** [Date]  
**Course:** [Course Name]

---

## 1. Introduction

This lab demonstrates the implementation of SSL/TLS encryption on a Node.js web server. We started with a basic HTTP server and upgraded it to use HTTPS with a self-signed certificate. This process illustrates the fundamental concepts of secure web communications.

## 2. Objectives

- Understand the role of SSL/TLS in securing web communications
- Generate a self-signed certificate and private key
- Modify a Node.js HTTP server to use HTTPS
- Test secure connections and verify certificate behavior
- Document and demonstrate the process

## 3. Methodology

### 3.1 Initial Setup

The lab began with a basic HTTP server (`server.js`) that listens on port 3000 and serves plain text responses without encryption.

### 3.2 Certificate Generation

**Method Used:** Node.js with `selfsigned` package (alternative to OpenSSL)

**Command:**
```bash
npm install
npm run generate-cert
```

**Certificate Details:**
- **Type:** Self-signed X.509 certificate
- **Validity:** 365 days
- **Key Size:** 2048 bits
- **Algorithm:** SHA-256
- **Common Name:** localhost

**Files Generated:**
- `certs/server.key` - Private key file
- `certs/server.cert` - Certificate file

> **Note:** Screenshot of certificate creation should be added here showing the terminal output.

### 3.3 Server Modification

The HTTP server was converted to HTTPS by:

1. Replacing `http` module with `https` module
2. Reading certificate and key files using `fs.readFileSync()`
3. Creating HTTPS server with certificate options
4. Changing port from 3000 to 3443 (standard HTTPS port alternative)
5. Updating response message to indicate secure connection

**Key Code Changes:**
```javascript
// Before (HTTP)
const http = require('http');
const server = http.createServer((req, res) => { ... });
server.listen(3000, ...);

// After (HTTPS)
const https = require('https');
const fs = require('fs');
const options = {
  key: fs.readFileSync('./certs/server.key'),
  cert: fs.readFileSync('./certs/server.cert'),
};
const server = https.createServer(options, (req, res) => { ... });
server.listen(3443, ...);
```

## 4. Testing and Results

### 4.1 HTTP Server Test

**Command:**
```bash
node server.js
```

**Access:** http://localhost:3000

**Result:** Server responds with "Hello, this is an insecure HTTP server!"

**Observations:**
- No security warnings
- Connection is unencrypted
- Data transmitted in plain text

### 4.2 HTTPS Server Test

**Command:**
```bash
node server_https.js
```

**Access:** https://localhost:3443

**Result:** Server responds with "🔐 Hello, this is a secure HTTPS server!"

**Browser Behavior:**
- Browser displays security warning
- Warning states: "Your connection is not private" or "NET::ERR_CERT_AUTHORITY_INVALID"
- User must click "Advanced" → "Proceed to localhost (unsafe)" to continue

> **Note:** Screenshot of browser access should be added here showing:
> - The security warning page
> - The successful connection after proceeding
> - The browser's certificate information

### 4.3 curl Testing

#### Test 1: curl with `-k` flag (insecure, bypasses certificate verification)

**Command:**
```bash
curl -k https://localhost:3443
```

**Expected Output:**
```
🔐 Hello, this is a secure HTTPS server!
```

**Analysis:** The `-k` flag tells curl to ignore certificate verification errors, allowing connection to proceed despite the self-signed certificate.

#### Test 2: curl without `-k` flag (secure, enforces certificate verification)

**Command:**
```bash
curl https://localhost:3443
```

**Expected Output:**
```
curl: (60) SSL certificate problem: self signed certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a trusted SSL connection to it. To learn more about this situation and
how to fix it, please visit the web url above.
```

**Analysis:** Without the `-k` flag, curl properly validates the certificate and rejects the connection because the certificate is self-signed and not from a trusted Certificate Authority.

> **Note:** Screenshot of curl test output should be added here showing both test results.

## 5. HTTP vs HTTPS Comparison

| Aspect | HTTP | HTTPS |
|--------|------|-------|
| **Port** | 3000 | 3443 |
| **Protocol** | HTTP (Hypertext Transfer Protocol) | HTTPS (HTTP over TLS/SSL) |
| **Encryption** | None - all data transmitted in plain text | All data encrypted using TLS/SSL |
| **Certificate Required** | No | Yes (SSL/TLS certificate) |
| **Browser Warning** | None | Shows warning for self-signed certificates |
| **Security Level** | Low - vulnerable to eavesdropping, man-in-the-middle attacks, data tampering | High - protects against eavesdropping, MITM attacks, and data tampering |
| **Performance** | Faster (no encryption overhead) | Slightly slower (encryption/decryption overhead) |
| **Use Case** | Development, internal networks | Production, sensitive data, public websites |
| **curl Behavior** | `curl http://localhost:3000` works normally | `curl https://localhost:3443` requires `-k` flag for self-signed certs |
| **Data Integrity** | No guarantee - data can be modified in transit | Guaranteed - any modification is detected |
| **Authentication** | No server identity verification | Server identity verified via certificate |

## 6. Why Browser Shows Warning

When accessing `https://localhost:3443`, browsers display a security warning for the following reasons:

### 6.1 Self-Signed Certificate

The certificate was generated locally using the `selfsigned` package (or OpenSSL) and is not signed by a trusted Certificate Authority (CA). Browsers maintain a list of trusted CAs (like Let's Encrypt, DigiCert, GlobalSign, etc.), and our certificate is not in that list.

### 6.2 Certificate Authority Validation

When a browser connects to an HTTPS site, it:
1. Receives the server's certificate
2. Checks if the certificate is signed by a trusted CA
3. Verifies the certificate hasn't expired
4. Confirms the certificate matches the domain name

Since our certificate fails step 2 (not signed by a trusted CA), the browser warns the user.

### 6.3 Security Feature

This warning is a **security feature**, not a bug. It protects users from:
- **Man-in-the-Middle Attacks:** Attackers could create fake certificates to intercept traffic
- **Phishing:** Malicious sites using invalid certificates
- **Spoofing:** Fake websites impersonating legitimate ones

### 6.4 Production vs Development

- **Development/Testing:** Self-signed certificates are acceptable for local development
- **Production:** Must use certificates from trusted CAs (free options: Let's Encrypt, Cloudflare)

## 7. Security Implications

### 7.1 What HTTPS Protects Against

1. **Eavesdropping:** Data is encrypted, so attackers cannot read it even if intercepted
2. **Tampering:** TLS detects any modification to data in transit
3. **Impersonation:** Certificate verifies server identity (when from trusted CA)

### 7.2 Limitations of Self-Signed Certificates

1. **No CA Verification:** Users must manually trust the certificate
2. **Browser Warnings:** Creates poor user experience
3. **Not Suitable for Production:** Public users cannot verify server identity

### 7.3 Best Practices

- Use self-signed certificates only for development
- Obtain certificates from trusted CAs for production
- Regularly renew certificates before expiration
- Use strong encryption algorithms (SHA-256, RSA 2048+ or ECC)

## 8. Code Files

### 8.1 server.js (HTTP Server)
```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello, this is an insecure HTTP server!');
});

server.listen(3000, () => {
  console.log('Server running at http://localhost:3000');
});
```

### 8.2 server_https.js (HTTPS Server)
```javascript
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('./certs/server.key'),
  cert: fs.readFileSync('./certs/server.cert'),
};

const server = https.createServer(options, (req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('🔐 Hello, this is a secure HTTPS server!');
});

server.listen(3443, () => {
  console.log('Secure server running at https://localhost:3443');
});
```

## 9. Deliverables Checklist

- ✅ Modified HTTPS server code (`server_https.js`)
- ✅ Certificate files (`server.cert`, `server.key` in `certs/` directory)
- ✅ Report document (this document)
- ⏳ Screenshot of certificate creation (to be added by student)
- ⏳ Browser access screenshot showing warning and successful connection (to be added by student)
- ⏳ curl test output screenshots (to be added by student)
- ⏳ 30-60 second demo video (to be created by student)

## 10. Conclusion

This lab successfully demonstrated:

1. **Certificate Generation:** Created a self-signed SSL/TLS certificate using Node.js
2. **Server Upgrade:** Converted an HTTP server to HTTPS with minimal code changes
3. **Security Testing:** Verified certificate behavior with browsers and curl
4. **Understanding:** Gained insight into why browsers warn about self-signed certificates

The implementation shows that adding SSL/TLS to a Node.js server is straightforward, requiring only:
- Certificate and key files
- The `https` module instead of `http`
- Certificate options passed to `createServer()`

For production environments, certificates should be obtained from trusted Certificate Authorities to ensure proper browser validation and user trust.

## 11. References

- [Node.js HTTPS Documentation](https://nodejs.org/api/https.html)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [Let's Encrypt](https://letsencrypt.org/) - Free SSL/TLS certificates
- [Mozilla SSL Configuration Guide](https://ssl-config.mozilla.org/)
- [OWASP Transport Layer Protection Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Protection_Cheat_Sheet.html)

---

**End of Report**


/**
 * Alternative certificate generation script using Node.js
 * This script generates a self-signed certificate using the 'selfsigned' package
 * 
 * To use this script:
 * 1. Install the package: npm install selfsigned
 * 2. Run: node generate-cert.js
 * 
 * OR use OpenSSL (if installed):
 * openssl req -nodes -new -x509 -keyout certs/server.key -out certs/server.cert -days 365
 */

const fs = require('fs');
const path = require('path');

// Check if selfsigned package is available
let selfsigned;
try {
  selfsigned = require('selfsigned');
} catch (e) {
  console.error('Error: The "selfsigned" package is not installed.');
  console.error('Please install it by running: npm install selfsigned');
  console.error('\nAlternatively, use OpenSSL:');
  console.error('  openssl req -nodes -new -x509 -keyout certs/server.key -out certs/server.cert -days 365');
  process.exit(1);
}

// Ensure certs directory exists
const certsDir = path.join(__dirname, 'certs');
if (!fs.existsSync(certsDir)) {
  fs.mkdirSync(certsDir);
}

// Generate certificate
const attrs = [{ name: 'commonName', value: 'localhost' }];
const pems = selfsigned.generate(attrs, { 
  days: 365,
  keySize: 2048,
  algorithm: 'sha256'
});

// Write certificate and key files
fs.writeFileSync(path.join(certsDir, 'server.cert'), pems.cert);
fs.writeFileSync(path.join(certsDir, 'server.key'), pems.private);

console.log('✅ Certificate generated successfully!');
console.log('   Certificate: certs/server.cert');
console.log('   Private Key: certs/server.key');
console.log('\nYou can now run: node server_https.js');


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


const https = require('https');

// Script to list all API tokens to find the token ID
const token = process.argv[2];

if (!token) {
  console.log('Usage: node list-tokens.js <api-token>');
  process.exit(1);
}

const options = {
  hostname: 'api.cloudflare.com',
  port: 443,
  path: `/client/v4/user/tokens`,
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
};

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    try {
      const result = JSON.parse(data);
      if (!result.success) {
        console.log('Failed to list tokens:', JSON.stringify(result, null, 2));
        return;
      }
      
      console.log('API Tokens:');
      result.result.forEach(token => {
        console.log(`ID: ${token.id}`);
        console.log(`Name: ${token.name}`);
        console.log(`Status: ${token.status}`);
        console.log(`Created: ${token.created_on}`);
        console.log('---');
      });
    } catch (error) {
      console.log('Error parsing response:', error);
      console.log('Response data:', data);
    }
  });
});

req.on('error', (error) => {
  console.error('Error:', error);
});

req.end();
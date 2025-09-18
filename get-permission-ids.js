const https = require('https');

// Script to get permission group IDs
const token = process.argv[2];

if (!token) {
  console.log('Usage: node get-permission-ids.js <api-token>');
  process.exit(1);
}

const options = {
  hostname: 'api.cloudflare.com',
  port: 443,
  path: `/client/v4/user/tokens/permission_groups`,
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
        console.log('Failed to get permission groups:', JSON.stringify(result, null, 2));
        return;
      }
      
      console.log('Permission Groups:');
      result.result.forEach(group => {
        console.log(`${group.id}: ${group.name}`);
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
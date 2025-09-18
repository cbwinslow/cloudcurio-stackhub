const https = require('https');

// Script to modify API token permissions
// Usage: node modify-token.js <token-manager-token> <token-id-to-modify>

const tokenManagerToken = process.argv[2];
const tokenIdToModify = process.argv[3];

if (!tokenManagerToken || !tokenIdToModify) {
  console.log('Usage: node modify-token.js <token-manager-token> <token-id-to-modify>');
  process.exit(1);
}

// Get the token details first
const getOptions = {
  hostname: 'api.cloudflare.com',
  port: 443,
  path: `/client/v4/user/tokens/${tokenIdToModify}`,
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${tokenManagerToken}`,
    'Content-Type': 'application/json'
  }
};

const getReq = https.request(getOptions, (res) => {
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    try {
      const result = JSON.parse(data);
      if (!result.success) {
        console.log('Failed to get token details:', JSON.stringify(result, null, 2));
        return;
      }
      
      const token = result.result;
      console.log('Current token details:', JSON.stringify(token, null, 2));
      
      // Now update the token with the required permissions
      const requiredPolicies = [
        {
          "effect": "allow",
          "resources": {
            "com.cloudflare.api.account.*": "*"
          },
          "permission_groups": [
            {
              "id": "0cc3e4caee6244358b4428d67550ed20", // Workers Scripts:Edit
              "name": "Workers Scripts:Edit"
            }
          ]
        },
        {
          "effect": "allow",
          "resources": {
            "com.cloudflare.api.account.*": "*"
          },
          "permission_groups": [
            {
              "id": "d14654d44305483c989c0d23c7c0537a", // D1:Edit
              "name": "D1:Edit"
            }
          ]
        },
        {
          "effect": "allow",
          "resources": {
            "com.cloudflare.api.account.*": "*"
          },
          "permission_groups": [
            {
              "id": "c874408097264d779c961eba050b6b41", // Analytics Engine:Edit
              "name": "Analytics Engine:Edit"
            }
          ]
        },
        {
          "effect": "allow",
          "resources": {
            "com.cloudflare.api.account.*": "*"
          },
          "permission_groups": [
            {
              "id": "31a0c7299e1e47598c9078fc5f64448f", // Workers KV Storage:Edit
              "name": "Workers KV Storage:Edit"
            }
          ]
        }
      ];
      
      // Combine with existing policies if any
      const updatedPolicies = [...requiredPolicies];
      
      const updatePayload = {
        name: token.name,
        policies: updatedPolicies,
        condition: token.condition
      };
      
      const updateOptions = {
        hostname: 'api.cloudflare.com',
        port: 443,
        path: `/client/v4/user/tokens/${tokenIdToModify}`,
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${tokenManagerToken}`,
          'Content-Type': 'application/json'
        }
      };
      
      const updateReq = https.request(updateOptions, (updateRes) => {
        let updateData = '';
        updateRes.on('data', (chunk) => {
          updateData += chunk;
        });
        
        updateRes.on('end', () => {
          try {
            const updateResult = JSON.parse(updateData);
            console.log('Token update result:', JSON.stringify(updateResult, null, 2));
          } catch (error) {
            console.log('Update response:', updateData);
          }
        });
      });
      
      updateReq.on('error', (error) => {
        console.error('Error updating token:', error);
      });
      
      updateReq.write(JSON.stringify(updatePayload));
      updateReq.end();
      
    } catch (error) {
      console.log('Error parsing response:', error);
      console.log('Response data:', data);
    }
  });
});

getReq.on('error', (error) => {
  console.error('Error getting token details:', error);
});

getReq.end();
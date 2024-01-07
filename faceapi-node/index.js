const https = require('https');
const fs = require('fs');
const formData2 = require('form-data');

const apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
const apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';

const requestUrl = 'https://api-us.faceplusplus.com/facepp/v3/compare';

const imageurl1 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_5.jpeg?alt=media&token=27e24282-d003-4a61-912c-a8717237eb7f';
const imageurl2 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_1.jpeg?alt=media&token=6febd89e-61ac-4318-8ac4-994876371669';

const formData = new formData2();
formData.append('api_key', apiKey);
formData.append('api_secret', apiSecret);
formData.append('image_url1', imageurl1);
formData.append('image_url2', imageurl2);

const options = {
  hostname: 'api-us.faceplusplus.com',
  port: 443,
  path: '/facepp/v3/compare',
  method: 'POST'
};

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    const response = JSON.parse(data);
    console.log(response);
  });
});

req.on('error', (error) => {
  console.error(error);
});

formData.pipe(req);
req.end();

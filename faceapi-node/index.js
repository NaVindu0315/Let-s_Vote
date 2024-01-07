const https = require('https');
const fs = require('fs');

const apiKey = 'YOUR_API_KEY';
const apiSecret = 'YOUR_API_SECRET';

const requestUrl = 'https://api-us.faceplusplus.com/facepp/v3/compare';

// Specify how you'll provide image data (choose one):
/*
const imageFile1 = fs.readFileSync('./path/to/image1.jpg');
const imageFile2 = fs.readFileSync('./path/to/image2.jpg');
// OR
const imageBase64_1 = fs.readFileSync('./path/to/image1.jpg').toString('base64');
const imageBase64_2 = fs.readFileSync('./path/to/image2.jpg').toString('base64');
// OR
const faceToken1 = 'face_token_1';
const faceToken2 = 'face_token_2';*/
const imageurl1 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_5.jpeg?alt=media&token=27e24282-d003-4a61-912c-a8717237eb7f';
const imageurl2 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_1.jpeg?alt=media&token=6febd89e-61ac-4318-8ac4-994876371669';

const formData = {
  api_key: apiKey,
  api_secret: apiSecret,
  // Choose one of the following based on your image data format:
 /* image_file1: imageFile1,
  image_file2: imageFile2,
  // OR
  image_base64_1: imageBase64_1,
  image_base64_2: imageBase64_2,
  // OR
  face_token1: faceToken1,
  face_token2: faceToken2*/
  image_url1: imageurl1,
  image_url2: imageurl2
};

const options = {
  hostname: 'api-us.faceplusplus.com',
  port: 443,
  path: '/facepp/v3/compare',
  method: 'POST',
  headers: {
    'Content-Type': 'multipart/form-data'
  }
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

req.write(formData);
req.end();

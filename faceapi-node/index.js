const request = require('request');

const apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
const apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';
const faceurl1 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_5.jpeg?alt=media&token=27e24282-d003-4a61-912c-a8717237eb7f';
const faceurl2 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/people%2Fwish_1.jpeg?alt=media&token=6febd89e-61ac-4318-8ac4-994876371669';

const formData = {
  api_key: apiKey,
  api_secret: apiSecret,
  image_url1: faceurl1,
  image_url2: faceurl2,
};

const options = {
  url: 'https://api-us.faceplusplus.com/facepp/v3/compare',
  method: 'POST',
  formData: formData,
};

request(options, (error, response, body) => {
  if (error) {
    console.error(error);
  } else {
    console.log(body); // Response from the Face++ API
  }
});
//dindnt work with below
/*

request(options, (error, response, body) => {
  if (error) {
    console.error(error);
  } else {
    const responseData = JSON.parse(body); // Parse the JSON response
    const confidence = responseData.confidence; // Access the confidence value
    console.log("Confidence:", confidence); // Log the confidence value
  }
});*/

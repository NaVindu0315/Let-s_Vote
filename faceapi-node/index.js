const axios = require('axios');

// Replace 'YOUR_API_KEY' with your actual API key
const apiKey = 'b87c9d9fa11b44f0a8df68b454d494f4';

// Define the endpoint URL for face detection
const endpoint = 'https://nav.cognitiveservices.azure.com/face/v1.0/detect';


// Set up the request headers
const headers = {
    'Content-Type': 'application/json',
    'Ocp-Apim-Subscription-Key': apiKey
   };

// Define the request body (optional)
const body = JSON.stringify({
    returnFaceId: true,
    returnFaceLandmarks: false,
    returnFaceAttributes: ['age', 'gender', 'headPose', 'smile', 'facialHair', 'glasses', 'emotion', 'hair', 'makeup', 'occlusion', 'accessories', 'blur', 'exposure', 'noise']
   });

// Make the request to the Azure Face API
axios.post(endpoint, body, { headers: headers })
 .then(response => console.log(response.data))
 .catch(error => console.error(error));
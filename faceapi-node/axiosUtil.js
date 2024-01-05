const axios = require('axios');

const instance = axios.create({
 baseURL: 'https://nav.cognitiveservices.azure.com/face/v1.0/detect/verify',
 headers: {
    'Ocp-Apim-Subscription-Key': 'YOUR_API_KEY',
    'Content-Type': 'application/json'
 },
 httpsAgent: new https.Agent({
    rejectUnauthorized: false
 })
});

module.exports = instance;
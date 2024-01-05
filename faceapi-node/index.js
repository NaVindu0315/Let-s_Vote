const axios = require('axios');
const subscriptionKey = 'b87c9d9fa11b44f0a8df68b454d494f4';
const uriBase = 'https://nav.cognitiveservices.azure.com/face/v1.0/detect';


const analyzeImages = async (imageUrl1, imageUrl2) => {
 const detectImage1 = async () => {
    try {
      const response = await axios.post(
        uriBase,
        { url: imageUrl1 },
        { headers: { 'Ocp-Apim-Subscription-Key': subscriptionKey } }
      );
      return response.data[0].faceId;
    } catch (error) {
      console.error('Error in detectImage1:', error);
    }
 };

 const detectImage2 = async () => {
    try {
      const response = await axios.post(
        uriBase,
        { url: imageUrl2 },
        { headers: { 'Ocp-Apim-Subscription-Key': subscriptionKey } }
      );
      return response.data[0].faceId;
    } catch (error) {
      console.error('Error in detectImage2:', error);
    }
 };

 const faceId1 = await detectImage1();
 const faceId2 = await detectImage2();

 const verifyFaces = async () => {
    try {
      const response = await axios.post(
        `${uriBase}/verify`,
        { faceId1, faceId2 },
        { headers: { 'Ocp-Apim-Subscription-Key': subscriptionKey } }
      );
      console.log('Faces verification result:', response.data);
    } catch (error) {
      console.error('Error in verifyFaces:', error);
    }
 };

 await verifyFaces();
};

const imageUrl1 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/images%2F2023-12-01%2012%3A39%3A43.963704.jpg?alt=media&token=f9258809-b452-4c64-a4ce-d88718e6f55e';
const imageUrl2 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/images%2F2023-12-01%2012%3A40%3A23.675609.jpg?alt=media&token=75db23b3-db0f-4efd-8bce-0ebcc32271f2';
analyzeImages(imageUrl1, imageUrl2);
const axios = require('axios');

// Replace with your Azure Face API subscription key and endpoint
const subscriptionKey = 'b87c9d9fa11b44f0a8df68b454d494f4';
const endpoint = 'https://nav.cognitiveservices.azure.com/';

// URLs of the images you want to compare
const imageUrl1 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/images%2F2023-12-01%2012%3A39%3A43.963704.jpg?alt=media&token=f9258809-b452-4c64-a4ce-d88718e6f55e';
const imageUrl2 = 'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/images%2F2023-12-01%2012%3A40%3A23.675609.jpg?alt=media&token=75db23b3-db0f-4efd-8bce-0ebcc32271f2';

// Function to detect face and get faceId
async function detectFace(imageUrl) {
    const response = await axios.post(`${endpoint}/face/v1.0/detect`, { url: imageUrl }, {
        headers: {
            'Content-Type': 'application/json',
            'Ocp-Apim-Subscription-Key': subscriptionKey
        },
        params: {
            returnFaceId: 'true'
        }
    });
    return response.data[0].faceId;
}

// Function to verify if two faces belong to the same person
async function verifyFaces(faceId1, faceId2) {
    const response = await axios.post(`${endpoint}/face/v1.0/verify`, { faceId1, faceId2 }, {
        headers: {
            'Content-Type': 'application/json',
            'Ocp-Apim-Subscription-Key': subscriptionKey
        }
    });
    return response.data.isIdentical;
}

// Main function to compare two images
async function compareImages() {
    try {
        const faceId1 = await detectFace(imageUrl1);
        const faceId2 = await detectFace(imageUrl2);
        const isIdentical = await verifyFaces(faceId1, faceId2);
        console.log(`The faces in the two images are identical: ${isIdentical}`);
    } catch (error) {
        console.error(error);
    }
}

compareImages();
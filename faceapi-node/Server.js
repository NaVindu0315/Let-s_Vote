const express = require('express');
const request = require('request');
const app = express();
app.use(express.json());

//for predefining the api key and secret
const apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
const apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';

app.post('/compareFaces', (req, res) => {
    const {  faceurl1, faceurl2 } = req.body;

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
            res.status(500).send('An error occurred');
        } else {
            const confvalue = JSON.parse(body).confidence;
            if(confvalue > 85){
                res.send({ message: "same person", confidence: confvalue });
            }
            else{ 
                res.send({ message: "different person", confidence: confvalue });
            }
        }
    });
});

const port = 3000;
app.listen(port, () => console.log(`Server is running on port ${port}`));
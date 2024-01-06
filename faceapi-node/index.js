const fs = require('fs');
const axios = require('axios');
const FormData = require('form-data');

const url = "https://api.luxand.cloud/v2/person";

const headers = {
    "token": "715d5e8c2dad468cae50ef2422e0883d",
};

const form = new FormData();
form.append("photos", fs.createReadStream('./sample_pictures/wish/wish_1.jpeg'));
form.append("name", "wish");
form.append("store", "1");
form.append("collections", "users");

headers['Content-Type'] = `multipart/form-data; boundary=${form.getBoundary()}`;

const options = {
  method: "POST",
  url: url,
  headers: headers,
  data: form
};

axios(options)
  .then(response => {
    console.log(response.data);
  })
  .catch(error => {
    console.error(error);
  });
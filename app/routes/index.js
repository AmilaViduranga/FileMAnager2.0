/*
 * handle the url for any get, put, post and delete request
 * developer : Amila
 */

 
var express = require('express');
var router = express.Router();

var ProfileImagesViewRoute = require('./moduleRoutes/DisplayRoutes/ProfileImagesViewRoute');

router.use('/files/profile_image', ProfileImagesViewRoute);

module.exports = router;

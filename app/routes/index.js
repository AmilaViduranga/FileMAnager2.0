/*
 * handle the url for any get, put, post and delete request
 * developer : Amila
 */

 
var express = require('express');
var router = express.Router();
var ControllerMap = require('../Controller/ControllerMap');

var ProfileImagesViewRoute = require('./moduleRoutes/DisplayRoutes/ProfileImagesViewRoute');
var ResourceViewRoute = require('./moduleRoutes/DisplayRoutes/ResourceViewRoute');
/*
 * avoide to use root route
 */
router.all('/', function(req, res, next) {
    ControllerMap.UserAuthController.unAuthorizedAccess(res);
})

router.use('/files/profile_image', ProfileImagesViewRoute);
router.use('/files/resources', ResourceViewRoute);

module.exports = router;

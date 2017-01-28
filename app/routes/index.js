/*
 * handle the url for any get, put, post and delete request
 * developer : Amila
 */

 
var express = require('express');
var router = express.Router();
var MapController = require('../Controller/ControllerMap');
var AuthController = MapController.UserAuthController;

router.get('/test_auth/', function(req, res, next) {
    AuthController.getId("test_token", function(data) {
        res.send(data);
    })
})

module.exports = router;

/**
 * Created by EDI-DELL-02 on 1/28/2017.
 */
/*
 * view profile images
 */
'use strict';

var express = require('express');
var fs = require('fs');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var ProfileImageViewController = ControllerMap.DisplayController.ProfileImagesViewController;
var ProfileImageUploadController = ControllerMap.UploadsController.ProfileImageUploadContoller;

/*
 * get the profile image of user
 */
router.get('/:token', function (req, res, next) {
    console.log("Find route");
    ProfileImageViewController.getImageUser(req.params.token, "profile", res);
});

/*
 * get the tubline of profile image
 */
router.get('/tumbline/:token', function(req, res, next) {
    ProfileImageViewController.getImageUser(req.params.token, "profile_tubline",res);
})

/*
 * post profile image file to file manager and db
 * */

router.post('/', function (req, res, next) {
    var sampleFile = req.files.sampleFile;
    var token = req.body.token;
    ProfileImageUploadController.getUser(token, sampleFile, res);
});

module.exports = router;
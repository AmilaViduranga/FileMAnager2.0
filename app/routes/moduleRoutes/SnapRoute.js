/**
 * Created by EDI-SD-06 on 2/1/2017.
 */
'use strict';

var express = require('express');
var fs = require('fs');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var snapUploadController = ControllerMap.UploadsController.SnapUploadController;
var snapViewController = ControllerMap.DisplayController.SnapViewController;

/*
 * get the files requested by client
 */
router.get('/:token/:snapID', function (req, res, next) {
    var token = req.params.token;
    var snapID = req.params.snapID;

    snapViewController.getImageUser(token, snapID, res);
});


/*
 * post profile image file to file manager and db
 * */

router.post('/', function (req, res, next) {


    var sampleFile = req.files.sampleFile;
    var token = req.body.token;
    var snap_name = req.body.snap_name;

    snapUploadController.getUserID(token, sampleFile, snap_name, res);
});

module.exports = router;

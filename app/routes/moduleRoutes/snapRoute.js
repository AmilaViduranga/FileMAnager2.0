/**
 * Created by EDI-SD-06 on 2/1/2017.
 */

var express = require('express');
var fs = require('fs');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var snapUploadController = ControllerMap.UploadsController.SnapUploadController;

/*
 * post profile image file to file manager and db
 * */

router.post('/', function (req, res, next) {


    var sampleFile = req.files.sampleFile;
    var token = req.body.token;
    var snap_name = req.body.snap_name;

    console.log("inside route");
    snapUploadController.getUserID(token, sampleFile, snap_name, res);
});

module.exports = router;

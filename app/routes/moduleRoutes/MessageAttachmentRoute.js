/**
 * Created by EDI-SD-06 on 2/2/2017.
 */
'use strict';

var express = require('express');
var fs = require('fs');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var attachmentUploadController = ControllerMap.UploadsController.AttachmentUploadController;

/*
 * post profile image file to file manager and db
 * */

router.post('/', function (req, res, next) {

    var sampleFile = req.files.attachment;
    var token = req.body.token;
    var messsageID = req.body.msgID;

    attachmentUploadController.getUserID(token, sampleFile, messsageID, res, 1)
});

/*
 * post profile image file to file manager and db
 * */

router.post('/helper', function (req, res, next) {

    var sampleFile = req.files.attachment;
    var token = req.body.token;
    var messsageID = req.body.msgID;

    attachmentUploadController.getUserID(token, sampleFile, messsageID, res, 3)
});

    /*
     * post students' massage file to file manager and db
     * developed by Ruwan
     * */
router.post('/student', function (req, res, next) {

    var sampleFile = req.files.attachment;
    var token = req.body.token;
    var messsageID = req.body.msgID;

    console.log("test");
    res.end();
});

module.exports = router;

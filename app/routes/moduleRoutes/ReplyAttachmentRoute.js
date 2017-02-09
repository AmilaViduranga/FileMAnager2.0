/**
 * Created by EDI-SD-06 on 2/2/2017.
 */
'use strict';

var express = require('express');
var fs = require('fs');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var attachmentUploadController = ControllerMap.UploadsController.AttachmentUploadController;
var AuthController = require('../../Controller/AuthController');

/*
 * post profile image file to file manager and db
 * */

router.post('/', function (req, res, next) {

    var sampleFile = req.files.attachment;
    var token = req.body.token;
    var messsageID = req.body.reply_id;

    attachmentUploadController.getUserID(token, sampleFile, messsageID, res, 2);

});

/*
 * post profile image file to file manager and db
 * */

router.post('/helper', function (req, res, next) {

    var sampleFile = req.files.attachment;
    var token = req.body.token;
    var messsageID = req.body.reply_id;

    attachmentUploadController.getUserID(token, sampleFile, messsageID, res, 4)

});

module.exports = router;

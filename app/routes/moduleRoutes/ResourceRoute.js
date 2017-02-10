/**
 * Created by amila on 1/31/17.
 */
/*
 * resourece viw and upload
 */

'use strict';

var express = require('express');
var router = express.Router();
var ControllerMap = require('../../Controller/ControllerMap');
var ResourceViewController = ControllerMap.DisplayController.ResourceViewController;
var ResourceUploadController = ControllerMap.UploadsController.ResourceUploadController;

/*
 * get the files requested by client
 */
router.get('/:token/:res_id/:file', function (req, res, next) {
    var token = req.params.token;
    var res_id = req.params.res_id;
    return ResourceViewController.getResource(token, res_id, res);
});

/*
 * resource upload
 * */

router.post('/', function (req, res, next) {

    var sampleFile = req.files.resource;
    var token = req.body.token;
    var resName = req.body.name;
    var resTypeID = req.body.typeid;
    var describe = req.body.summary;
    var heading = req.body.hedingid;
    var unit = req.body.uid;
    var tags = req.body.tagid;

    var tagArr = tags.split(',');
    for (var i = 0; i < tagArr.length; i++) {
        tagArr[i] = +tagArr[i];
    }

    ResourceUploadController.getUserID(sampleFile, token, resName, resTypeID, describe, heading, unit, tagArr, res);

});
module.exports = router;
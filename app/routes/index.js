/*
 * handle the url for any get, put, post and delete request
 * developer : Amila
 */

'use strict';

var express = require('express');
var router = express.Router();

var ControllerMap = require('../Controller/ControllerMap');

var ProfileImagesViewRoute = require('./moduleRoutes/ProfileImagesViewRoute');
var SnapRoute = require('./moduleRoutes/snapRoute');
var MessageAttachment = require('./moduleRoutes/MessageAttachmentRoute');
var ReplyAttachment = require('./moduleRoutes/ReplyAttachmentRoute');
var ResourceViewRoute = require('./moduleRoutes/ResourceRoute');

router.use('/files/profile_image', ProfileImagesViewRoute);
router.use('/files/snap', SnapRoute);
router.use('/files/message', MessageAttachment);
router.use('/files/reply', ReplyAttachment);

router.use('/files/resources', ResourceViewRoute);
/*
 * avoide to use root route
 */
router.all('/', function (req, res, next) {
    ControllerMap.UserAuthController.unAuthorizedAccess(res);
})

module.exports = router;

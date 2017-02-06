/*
 * handle the url for any get, put, post and delete request
 * developer : Amila
 */

 
var express = require('express');
var router = express.Router();

var ProfileImagesViewRoute = require('./moduleRoutes/ProfileImagesViewRoute');
var SnapRoute = require('./moduleRoutes/snapRoute');
var MessageAttachment= require('./moduleRoutes/MessageAttachmentRoute');
var ReplyAttachment= require('./moduleRoutes/ReplyAttachmentRoute');

router.use('/files/profile_image', ProfileImagesViewRoute);
router.use('/files/snap', SnapRoute);
router.use('/files/message',MessageAttachment);
router.use('/files/reply',ReplyAttachment);

module.exports = router;

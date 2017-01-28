/**
 * Created by EDI-DELL-02 on 1/28/2017.
 */
/*
 * view profile images
 */

var express = require('express');
var router = express.Router();
var ControllerMap = require('../../../Controller/ControllerMap');
var ProfileImageViewController = ControllerMap.DisplayController.ProfileImagesViewController;

/*
 * get the profile image of user
 */
router.get('/:token', function(req, res, next) {
    ProfileImageViewController.getImageUser(req.params.token, res);
});

module.exports = router;
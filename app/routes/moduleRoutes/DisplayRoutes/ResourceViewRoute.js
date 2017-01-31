/**
 * Created by amila on 1/31/17.
 */
/*
 * view the files
 */

var express = require('express');
var router = express.Router();
var ControllerMap = require('../../../Controller/ControllerMap');
var ResourceViewController = ControllerMap.DisplayController.ResourcesViewController;

/*
 * get the files requested by client
 */
router.get('/:token/:res_id/:file', function(req, res, next) {
    var token = req.params.token;
    var res_id = req.params.res_id;
    return ResourceViewController.getResource(token, res_id, res);
})

module.exports = router;
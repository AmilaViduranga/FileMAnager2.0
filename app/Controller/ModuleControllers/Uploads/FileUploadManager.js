/**
 * Created by EDI-SD04 on 1/28/2017.
 */


var AuthController = require('../../AuthController');
var express = require('express');
var PathManager = require('../../../models/PathManager');
var fileUpload = require('express-fileupload');


/*
 * insert the file into folder
 * parameter: file ,file path
 * */

module.exports = {

    uploadFile: function (file, file_path, res, callback) {
        console.log("inside upload file");
        if (!file) {
            AuthController.invalidFormat(res);

        }
        else {
            file.mv(file_path, function (err, response) {
                if (err) {
                    console.log("inside err");
                    AuthController.unSuccess(res);
                }
                else {
                    return callback(response);
                    console.log("inside usucess");
                }
            });
        }
    }


}


/**
 * Created by EDI-SD-06 on 2/1/2017.
 */
'use strict';

var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileUploadManager = require('../../../Controller/ModuleControllers/Uploads/FileUploadManager');
var microtime = require('microseconds');
var validation = require('../../../Controller/ModuleControllers/Uploads/validation');
var thumbnail = require('../../../Controller/ModuleControllers/Uploads/thumbnail');

function snapUploadController() {

    /**
     * validate user id by token and
     * insert snap file details to the database
     * **/

    this.getUserID = function (token, file, snap_name, res) {
        if (!token || !file || !snap_name) {
            AuthController.nullData(res);
        }
        else {
            var file_name = Math.round(microtime.now());
            var userID = 0;

            /*
             get extension of the image
             */
            var exten = validation.extenConvert(file.mimetype);
            var validImage = validation.isImage(exten);

            /*
             file saving path set
             */
            var file_path = PathManager.snap + file_name + '.' + exten;
            var thumbnail_path = PathManager.snap_thumbnail + file_name + '.' + exten;

            if (validImage == true) {
                return AuthController.getId(token, res, function (data) {
                    if (data.user_id != null) {
                        userID = data.user_id;
                        /*
                         * inser snap to the folder
                         * */

                        return FileUploadManager.uploadFile(file, file_path, res, function (data) {
                            /*
                             * insert snap thumbnail
                             * */

                            thumbnail.uploadThumbnail(file_path, thumbnail_path);
                            return InsertSnap(userID, file_name, exten, snap_name, res);
                        });
                    }
                    else {
                        AuthController.AccessDeniedMessage(res);
                    }
                });

            } else {
                AuthController.invalidFormat(res);
            }
        }

    }

    /**
     * insert file details of the image to the db
     * **/

    var InsertSnap = function (userID, file_name, exten, snap_name, res) {
        getStudentID(userID, res, function (data) {
            if (data) {
                var query = {
                    type: QueryManager.callingType.select,
                    statement: 'SELECT fnInsertSnap(" ' + snap_name + '",' + data.fnGetStudentID + ' ,"' + file_name + '" ,"' + exten + '" ) AS st;'
                }
                return QueryManager.callFileManagerQuery(query, function (response) {
                    if (response[0].st == "T") {
                        AuthController.Success(res);
                    }
                    else {
                        AuthController.unSuccess(res);
                    }
                });
            } else {
                AuthController.notAvailable(res);
            }
        });

    }

    /**
     * get StudentID from userID
     * **/

    var getStudentID = function (userID, res, callback) {

        var query = {
            type: QueryManager.callingType.select,
            statement: 'SELECT  `fnGetStudentID` (' + userID + ') AS  `fnGetStudentID`;'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {
            if (response[0].fnGetStudentID > 0) {
                return callback(response[0]);
            } else if (response[0].fnGetStudentID == 0) {

                AuthController.AccessDeniedMessage(res);
            }
            else {
                AuthController.unSuccess(res);
            }

        });

    }

}
module.exports = new snapUploadController();
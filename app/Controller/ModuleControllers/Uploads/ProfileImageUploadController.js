/**
 * Created by EDI-SD-06 on 1/30/2017.
 */
'use strict';

var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileUploadManager = require('../../../Controller/ModuleControllers/Uploads/FileUploadManager');
var microtime = require('microseconds');
var validation = require('../../../Controller/ModuleControllers/Uploads/validation');
var thumbnail = require('../../../Controller/ModuleControllers/Uploads/thumbnail');
/*
 * upload profile picture of the user
 * */

function ProfileUploadController() {

    /*
     * get image user id from authcontroller
     * */

    this.getUser = function getUser(token, file, res) {
        if (!token || !file) {
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
            var file_path = PathManager.profile_images + file_name + '.' + exten;


            if (validImage == true) {

                return AuthController.getId(token, res, function (data) {
                    if (data.user_id != null) {
                        userID = data.user_id;

                        /*
                         * insert profile picture to the files
                         * */
                        return FileUploadManager.uploadFile(file, file_path, res, function (rest) {

                            /*
                             * insert thumbnil of the profile image
                             * */
                            var thumbnail_path = PathManager.profile_thumbnails + file_name + '.' + exten;
                            thumbnail.uploadThumbnail(file_path, thumbnail_path);
                            return insertProfileImage(userID, file_name, exten, res);


                        });

                    } else {
                        AuthController.AccessDeniedMessage(res);
                    }
                });
            }

            else {
                AuthController.invalidFormat(res);
            }
        }
    }

    /**
     * insert profile image to the db
     * parameter: userid, file name, extension name
     */

    var insertProfileImage = function (user_id, file_name, file_ext, res) {

        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL `spUploadProfilePicture` (' + user_id + ',"' + file_name + '","' + file_ext + '", @p); SELECT @p AS  `st` ;'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {

            if (response[1]["0"].st == "T") {
                AuthController.Success(res);

            }
            else {
                AuthController.unSuccess(res);
            }

        });
    }


}
module.exports = new ProfileUploadController();
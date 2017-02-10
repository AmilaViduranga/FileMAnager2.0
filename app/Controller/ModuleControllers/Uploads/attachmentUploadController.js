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

/**
 * upload user attachment for message
 * **/

function attachmentUploadController() {
    /**
     * validate user id by token and
     * insert attachment file details to the database
     * **/

    this.getUserID = function (token, file, messageID, res, type) {
        if(!token || !file || !messageID){
            AuthController.nullData(res);
        }
        else {
            var file_name = Math.round(microtime.now());
            var exten = validation.extenConvert(file.mimetype);

            var student_path = PathManager.attachment.student + file_name + '.' + exten;
            var helper_path = PathManager.attachment.helper + file_name + '.' + exten;

            return AuthController.getId(token, res, function (data) {
                if (data.user_id != null) {
                    /*
                     * insert student messages
                     * */

                    if (type == 1 || type == 2) {
                        return FileUploadManager.uploadFile(file, student_path, res, function (data) {
                            if (type == 1)
                                return insertMessageAttachment(file_name, exten, messageID, res);
                            else if (type == 2)
                                return insertReplyAttachment(file_name, exten, messageID, res);
                            else
                                AuthController.unSuccess(res);
                        });
                    }
                    /*
                     * insert helper messages
                     * */

                    else if (type == 3 || type == 4) {
                        return FileUploadManager.uploadFile(file, helper_path, res, function (data) {
                            if (type == 3)
                                return insertTutorHelpMessageAttachment(file_name, exten, messageID, res);
                            else if (type == 4)
                                return insertTutorHelpReplyAttachment(file_name, exten, messageID, res);
                            else
                                AuthController.unSuccess(res);
                        });
                    }
                    else
                        AuthController.unSuccess(res);
                }
            });
        }
    }

    /**
     * insert file details of the reply attachment to the db
     * **/

    var insertMessageAttachment = function (file_name, exten, messageID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'SELECT fnInsertMessageAttachment(' + messageID + ' ,"' + file_name + '" ,"' + exten + '" ) AS st;'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {

            if (response[0].st == "T") {
                AuthController.Success(res);

            }
            else {
                AuthController.unSuccess(res);
            }

        });
    }


    /**
     * insert file details of the reply attachment to the db
     * **/

    var insertReplyAttachment = function (file_name, exten, messageID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'SELECT fnInsertReplyAttchment(' + messageID + ' ,"' + file_name + '" ,"' + exten + '" ) AS st;'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {

            if (response[0].st == "T") {
                AuthController.Success(res);

            }
            else {
                AuthController.unSuccess(res);
            }

        });
    }

    /*
     * insert tutor help messsage attachment
     * */

    var insertTutorHelpMessageAttachment = function (file_name, exten, messageID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL spInsertTutorHelpMessageAttachment(' + messageID + ' ,"' + file_name + ' ","' + exten + '", @p ); SELECT @p AS st;'
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

    /*
     * insert tutor help reply attachment
     * */

    var insertTutorHelpReplyAttachment = function (file_name, exten, messageID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL spInsertTutorHelpReplyAttachment(' + messageID + ' ,"' + file_name + '" ,"' + exten + '", @p ); SELECT @p AS st;'
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

module.exports = new attachmentUploadController();
/**
 * Created by EDI-SD-06 on 2/1/2017.
 */

var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileUploadManager = require('../../../Controller/ModuleControllers/Uploads/FileUploadManager');
var microtime = require('microseconds');
var validation = require('../../../Controller/ModuleControllers/Uploads/validation');

function snapUploadController(){

    /**
     * validate user id by token and
     * insert snap file details to the database
     * **/

    this.getUserID = function (token , file, snap_name, res) {
        var file_name = Math.round(microtime.now());
        var vaildImage = false;
        var userID = 0;

        /*
         get extension of the image
         */
        var exten = validation.extenConvert(file.mimetype);
        validImage = validation.isImage(exten);

        /*
         file saving path set
         */
        var file_path = PathManager.snap + file_name + '.' + exten;
        var thumbnail_path = PathManager.snap_thumbnail + file_name + '.' + exten;

        if (validImage = true) {
            return AuthController.getId(token, function (data) {
                if (data.user_id != null) {

                    /*
                    * inser snap to the folder
                    * */

                    return FileUploadManager.uploadFile(file, file_path, function (res) {
                        return InsertSnap(userID, file_name, exten, snap_name, res);
                    });

                    /*
                    * insert snap thumbnail
                    * */
                    return FileUploadManager.uploadFile(file, thumbnail_path,res);
                }
            });

        }
    }

    /**
     * insert file details of the image to the db
     * **/

    var InsertSnap = function (userID, file_name, exten, snap_name, res) {

        var studentID = getStudentID(userID);

        var query = {
            type: QueryManager.callingType.insert,
            statement: 'SELECT fnInsertSnap('+snap_name+' ,' + studentID+' ,' +file_name +' ,'+ exten+' ) AS st;'
        }

        return QueryManager.callFileManagerQuery(query, function(response) {

            if(response[0].st = "T"){
                AuthController.Success(res);

            }
            else{
                AuthController.unSuccess(res);
            }

        });
    }

    /**
     * get StudentID from userID
     * **/

    var getStudentID = function (userID) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'SELECT  `fnGetStudentID` ('+userID +') AS st;'
        }

        return QueryManager.callFileManagerQuery(query, function(response) {

            if(response[0].st > 0){
                return response[0].st;
            }
            else{
                AuthController.unSuccess(res);
            }

        });

    }

}
 module.exports = new snapUploadController();
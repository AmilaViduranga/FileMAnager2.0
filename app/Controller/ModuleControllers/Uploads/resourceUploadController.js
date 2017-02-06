/**
 * Created by EDI-SD-06 on 2/1/2017.
 */
var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileUploadManager = require('../../../Controller/ModuleControllers/Uploads/FileUploadManager');
var microtime = require('microseconds');
var validation = require('../../../Controller/ModuleControllers/Uploads/validation');

/*
* upload resources
* */

function recourceUploadController(){

    /*
     * get resource uploader user id from authcontroller
     * */

    this.getUserID = function (token , file, res) {

        var file_name =  Math.round(microtime.now());
        var exten = validation.extenConvert(file.mimetype);
        var file_path = PathManager.profile_images+ file_name+'.'+exten;

        return AuthController.getId(token, function(data) {
            if(data.user_id != null) {
                return FileUploadManager.uploadFile(file,file_path,function (res) {
                    return insertResource(file_name, exten, res);
                });
            }
        });
    }

    /*
    * insert resource file detilas to db
    * */

    var insertResource = function (file_name,ext,res_name,res_type,describe,heading_id, unit_id) {

        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL spInsertResource ('+file_name+','+ ext+ ','+ res_name+','+ res_type+', @p1 ,@p2 ,'+ describe+ ','+ heading_id+','+ unit_id +'); SELECT @p1 AS `st`, @p2 AS `resourceID`;'
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
}

module.exports = new recourceUploadController();
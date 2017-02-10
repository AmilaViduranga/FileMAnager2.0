/**
 * Created by EDI-SD-06 on 2/1/2017.
 */
var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileUploadManager = require('../../../Controller/ModuleControllers/Uploads/FileUploadManager');
var microtime = require('microseconds');
var validation = require('../../../Controller/ModuleControllers/Uploads/validation');
var Connection = require('../../../models/Connection');
/*
 * upload resources
 * */

function resourceUploadController() {

    /*
     * get resource uploader user id from authcontroller
     * */

    this.getUserID = function (file, token, resName, resTypeID, describe, heading, unit, tags, res) {
        if(!file || !token || !resName || !resTypeID || !heading || !unit || !tags ){
            AuthController.nullData(res)
        }
        else {
            var file_name = Math.round(microtime.now());
            var exten = validation.extenConvert(file.mimetype);

            var animation_path = PathManager.resoursces.animation + file_name + '.' + exten;
            var interactive_activity_path = PathManager.resoursces.interactive_activities + file_name + '.' + exten;
            var knowledge_nuget_path = PathManager.resoursces.knowledge_nuget + file_name + '.' + exten;
            var presentation_path = PathManager.resoursces.presentation + file_name + '.' + exten;
            var revision_note_path = PathManager.resoursces.revision_note + file_name + '.' + exten;
            var video_path = PathManager.resoursces.video + file_name + '.' + exten;
            var worksheet_path = PathManager.resoursces.worksheet + file_name + '.' + exten;
            var other_path = PathManager.resoursces.other + file_name + '.' + exten;

            return AuthController.getId(token, res, function (data) {
                if (data.user_id != null) {
                    if (resTypeID == 2) {
                        return FileUploadManager.uploadFile(file, video_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 3) {
                        return FileUploadManager.uploadFile(file, animation_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 4) {
                        return FileUploadManager.uploadFile(file, presentation_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 5) {
                        return FileUploadManager.uploadFile(file, interactive_activity_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 6) {
                        return FileUploadManager.uploadFile(file, knowledge_nuget_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 7) {
                        return FileUploadManager.uploadFile(file, revision_note_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else if (resTypeID == 8) {
                        return FileUploadManager.uploadFile(file, worksheet_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }
                    else {
                        return FileUploadManager.uploadFile(file, other_path, res, function (data) {
                            return insertResource(file_name, exten, resName, resTypeID, describe, heading, unit, tags, res);
                        });
                    }

                }
            });
        }
    }

    /*
     * insert resource file detilas to db
     * */

    var insertResource = function (file_name, ext, res_name, res_type, describe, heading_id, unit_id, tags, res) {

        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL spInsertResource ( "' + file_name + '","' + ext + '","' + res_name + '",' + res_type + ', @p1 ,@p2 ,"' + describe + '",' + heading_id + ',' + unit_id + '); SELECT @p1 AS `st`, @p2 AS `resourceID`;'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {

            if (response[1]["0"].st == "T") {
                /*
                 * insert resurce tag by a loop
                 * */

                for (i = 0; i < tags.length; i++) {
                    Connection.query('CALL spInsertResourceTags (' + response[1]["0"].resourceID + ',' + tags[i] + ' ,@p1); SELECT @p1 AS `st`;', function (err, data) {
                        if (err) throw err;

                    });
                }
                AuthController.Success(res);

            }
            else {
                AuthController.unSuccess(res);
            }
        });
    }
}

module.exports = new resourceUploadController();
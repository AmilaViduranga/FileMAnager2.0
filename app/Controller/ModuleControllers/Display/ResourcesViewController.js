/**
 * Created by amila on 1/30/17.
 */
var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileStream = require('./FileStreamer');

function ResourcesViewController() {
    /*
     * get the file with validation checkup
     */
    this.getResource = function(token, resourceId, res) {
        return AuthController.getId(token, res, function(data) {
            if(data != null) {
                return QueryManager.callFileManagerQuery({
                    type: QueryManager.callingType.select,
                    statement: "CALL `spGetStudentFromToken` ('"+token+"', @user_id, @std_id, @pak_id, @country_id, @grade_id, @role); SELECT @std_id AS std_id, @pak_id AS pak_id;"
                }, function(response) {
                    if(response[0] != null) {
                        return checkAvailabilityOfResource(response[1][0].pak_id, resourceId, function(data) {
                            if(data) {
                                return getFileInfo(resourceId, function(data) {
                                    if(data) {
                                        return locationFinder(data[0][0], function(basePath) {
                                            if(basePath) {
                                                return FileStream.fileStream(basePath+data[0][0].name+data[0][0].extension, data[0][0], res);
                                            } else {
                                                return AuthController.notAvailable(res);
                                            }
                                        });
                                    } else {
                                        return AuthController.notAvailable(res);
                                    }
                                })
                            } else {
                                return AuthController.notAvailable(res);
                            }
                        })
                    } else {
                        return AuthController.notAvailable(res);
                    }
                })
            } else {
                return AuthController.AccessDeniedMessage(res);
            }
        })
    }

    /*
     * check that is the resource is available for that package
     */
    function checkAvailabilityOfResource(package_id, resourceId, callback) {
        return QueryManager.callFileManagerQuery({
            type: QueryManager.callingType.select,
            statement: "CALL `spGetPackageResource` ('"+package_id+"', @resID);"
        }, function(data) {
            if(data[0] != null) {
                data = Object.keys(data[0]).map(function(key) { return data[0][key] });
                data.forEach(function(resource) {
                    if(resource.resource_id == resourceId) {
                        return callback(true);
                    }
                })
            } else {
                return callback(false);
            }
        })
    }

    /*
     * get the resource file using resource id
     */
    function getFileInfo(res_id, callback) {
        return QueryManager.callFileManagerQuery({
            type: QueryManager.callingType.select,
            statement: "CALL `spGetResourceFile` ('"+res_id+"');"
        }, function(data) {
            if(data) {
                return callback(data);
            } else {
                return callback(false);
            }
        })
    }

    /*
     * select the file path location before send file to client
     */
    function locationFinder(fileDetails, callback) {
        var basepath = null;
        var fileType = fileDetails.Type;
        switch (fileType) {
            case "Video" :
                basepath = PathManager.resoursces.video;
                break;
            case "Animation":
                basepath = PathManager.resoursces.animation;
                break;
            case "Presetnation":
                basepath = PathManager.resoursces.presentation;
                break;
            case "Interactive Activity":
                basepath = PathManager.resoursces.interactive_activities;
                break;
            case "Knowledge Nugget":
                basepath = PathManager.resoursces.knowledge_nuget;
                break;
            case "Revision Notes":
                basepath = PathManager.resoursces.revision_note;
                break;
            case "Worksheets":
                basepath = PathManager.resoursces.worksheet;
                break;
        }
        return callback(basepath);
    }

}

module.exports = new ResourcesViewController();
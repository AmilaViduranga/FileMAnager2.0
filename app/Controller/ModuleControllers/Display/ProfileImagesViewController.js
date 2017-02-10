/**
 * Created by EDI-DELL-02 on 1/28/2017.
 */
var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileStream = require('./FileStreamer');
/*
 * handle all the functions related to the profile images
 */
function ProfileImagesViewController() {
    /*
     * get the exact profile image
     */
    this.getImageUser = function(token, neededType, res) {
        return AuthController.getId(token, res, function(data) {
            if(data.user_id != null) {
                return getImageContents(data.user_id, neededType, res);
            } else {
                return AuthController.AccessDeniedMessage(res);
            }
        })
    }

    /*
     * use to get the image name from db
     */
    function getImageContents(user_id, type, res) {
        var query = {
            type: QueryManager.callingType.insert,
            statement: 'CALL `spGetProfilePic` ('+user_id+');'
        }
        return QueryManager.callFileManagerQuery(query, function(response) {
            if(response.status == 500) {
                return AuthController.unSuccess(res);
            }
            if(type == "profile") {
                return FileStream.fileStream(PathManager.profile_images+response[0].name+"."+response[0].extension, response[0].name, res);
            } else if(type == "profile_tubline") {
                return FileStream.fileStream(PathManager.profile_thumbnails+response[0].name+"."+response[0].extension, response[0].name, res);
            }
        })
    }
}

module.exports = new ProfileImagesViewController();
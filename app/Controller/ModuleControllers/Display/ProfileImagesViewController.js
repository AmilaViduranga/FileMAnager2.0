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
    this.getImageUser = function(token, res) {
        return AuthController.getId(token, function(data) {
            if(data.user_id != null) {
                return getImageContents(data.user_id, res);
            }
        })
    }

    /*
     * use to get the image name from db
     */
    function getImageContents(user_id, res) {
        var query = {
            type: QueryManager.callingType.insert,
            statement: 'CALL `fnUploadProfilePicture` ('+user_id+');'
        }
        return QueryManager.callFileManagerQuery(query, function(response) {
            return FileStream.fileStream(PathManager.profile_images+response[0][0].name+"."+response[0][0].extension, response[0][0].name, res);
        })
    }
}

module.exports = new ProfileImagesViewController();
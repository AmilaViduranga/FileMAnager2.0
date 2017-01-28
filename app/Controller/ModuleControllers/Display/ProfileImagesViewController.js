/**
 * Created by EDI-DELL-02 on 1/28/2017.
 */
var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var fs = require('fs');
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
            type: QueryManager.callingType.select,
            statement: 'CALL `spGetProfilePic` ('+user_id+');'
        }
        return QueryManager.callFileManagerQuery(query, function(response) {
            return getImageFile(response.name+"."+response.extension, response.name, res);
        })
    }

    /*
     * file get the file
     */
    function getImageFile(filePath, file, res) {
        return fs.exists(PathManager.profile_images+filePath, function(exists) {
            if(exists) {
                res.writeHead(200, {
                    'Content-Type': 'application/octet-stream',
                    'Content-Disposition': 'attachment; filename'+file
                });
                return fs.createReadStream(filePath).pipe(res);
            }
        })
    }
}

module.exports = new ProfileImagesViewController();
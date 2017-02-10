/**
 * Created by EDI-SD-06 on 2/9/2017.
 */

'use strict';

var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileStream = require('./FileStreamer');

/*
 * get snap file with thumbnail
 * */

function SnapViewController() {
    /*
     * validate user
     */
    this.getImageUser = function (token, snapID, res) {
        return AuthController.getId(token, res, function (data) {
            if (data.user_id != null) {
                return getSnap(snapID, res);
            } else {
                return AuthController.AccessDeniedMessage(res);
            }
        });
    }

    /**
     * get snap details
     * **/

    var getSnap = function (snapID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL `spGetSnapFile` (' + snapID + ');'
        }

        return QueryManager.callFileManagerQuery(query, function (response) {
            if (response[0]["0"].name != "NULL")
                return FileStream.fileStream(PathManager.snap + response[0]["0"].name + "." + response[0]["0"].extension, response[0]["0"].name, res);

            else
                AuthController.nullData(res);

        });
    };
}

module.exports = new SnapViewController();
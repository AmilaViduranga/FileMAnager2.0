/**
 * Created by EDI-SD-06 on 2/9/2017.
 */

'use strict';

var AuthController = require('../../AuthController');
var QueryManager = require('../../../models/QueryManager');
var PathManager = require('../../../models/PathManager');
var FileStream = require('./FileStreamer');
var Connection = require('../../../models/Connection');

function AttachmentViewController() {
    /*
     * validate user
     */
    this.getUserID = function (token, messageID, res) {
        return AuthController.getId(token, res, function (data) {
            if (data.user_id != null) {
                return getAllMessageAttachment(data.user_id,messageID, res);
            } else {
                return AuthController.AccessDeniedMessage(res);
            }
        });
    }

    /**
     * validate message with userID
     * **/

    var getAllMessageAttachment = function (userID, messageID, res) {
        // var query = {
        //     type: QueryManager.callingType.select,
        //     statement: 'CALL `spGetUserMessageID` (' + userID + ');'
        // }
        //
        // return QueryManager.callFileManagerQuery(query, function (response) {
        //     console.log(response[0]["0"].id);
        //     var isFound = false;
        //     if (response[0]["0"].id != "NULL"){
        //        console.log(response[0].length);
        //     }
        //
        //
        //     else
        //         AuthController.nullData(res);
        //
        // });

        Connection.query('CALL spGetUserMessageID (' + userID + ');', function (err, rows) {
            if (err) throw err;
            console.log('Data received from Db:\n');
            console.log(err);

        });
     };

    /**
     * get all attachment of the message
     * **/

    var getMsgAttachFile = function (msgID) {
        // db.query(
        //     'CALL `spGetMessageAttachment` (?);',
        //     [msgID],
        //     function (err,result) {
        //         if (err) throw err;
        //         console.log(result[0]);
        //         var file = result[0][0];
        //         stream_file(res, file.name,file.extension);
        //     }
        // )

    };

    /**
     * validate reply with userID
     * **/

    var getAllReplyAttachment = function (userID, res) {
        var query = {
            type: QueryManager.callingType.select,
            statement: 'CALL `spGetUserMessageID` (' + userID + ');'
        }

        //     return QueryManager.callFileManagerQuery(query, function (response) {
        //         if (response[0]["0"].name != "NULL")
        //             return FileStream.fileStream(PathManager.snap + response[0]["0"].name + "." + response[0]["0"].extension, response[0]["0"].name, res);
        //
        //         else
        //             AuthController.nullData(res);
        //
        //     });
    };


    /**
     * get all attachment of the reply
     * **/
    var getReplyAttachFile = function (replyID) {
        // db.query(
        //     'CALL `spGetReplyAttachment` (?);',
        //     [replyID],
        //     function (err,result) {
        //         if (err) throw err;
        //         console.log(result[0]);
        //         var file = result[0][0];
        //         stream_file(res, file.name,file.extension);
        //     }
        // )

    };

    /**
     * get all attachment of the helper message
     * **/

    var getHeplerMsgAttachFile = function (msgID) {
        // db.query(
        //     'CALL `spGetMessageAttachment` (?);',
        //     [msgID],
        //     function (err,result) {
        //         if (err) throw err;
        //         console.log(result[0]);
        //         var file = result[0][0];
        //         stream_file(res, file.name,file.extension);
        //     }
        // )

    };

    /**
     * get all attachment of the helper reply
     * **/
    var getHelperReplyAttachFile = function (replyID) {
        // db.query(
        //     'CALL `spGetReplyAttachment` (?);',
        //     [replyID],
        //     function (err,result) {
        //         if (err) throw err;
        //         console.log(result[0]);
        //         var file = result[0][0];
        //         stream_file(res, file.name,file.extension);
        //     }
        // )

    };


}
module.exports = new AttachmentViewController();
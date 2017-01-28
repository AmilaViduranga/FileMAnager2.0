/**
 * Created by EDI-SD04 on 1/28/2017.
 */
var queryManager= require('./../models/QueryManager');
/*
 * auth the user id
 */
function AuthController(){

    /*
     * get the user id for given token
     */
    this.getId = function(token, callback) {
        return queryManager.callFileManagerQuery({
            type:queryManager.callingType.select,
            statement: 'CALL `spGetUserToken` ( "'+token+'" ,@user_id , @role); Select @user_id as user_id, @user_role as user_role'
        }, function(response) {
            return callback(response[1][0]);
        })
    }
}

module.exports = new AuthController();
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

    /*
     * Access denied message
     */
    this.AccessDeniedMessage = function(res) {
        res.write(JSON.stringify({
            status: 401,
            message: 'Access denied. Invalid Token'
        }));
        res.send();
    }

    /*
     * Unauthorized access
     */
    this.unAuthorizedAccess = function(res) {
        res.writeHead(401, {"Content-Type": "application/json"});
        res.write(JSON.stringify({
            status:401,
            message:'Unauthorized',
        }));
        res.send();
    }

    /*
     * not available resources in file manager
     */
    this.notAvailable = function(res) {
        res.write(JSON.stringify({
            status: 401,
            message: 'Access denied or invalid resource id'
        }));
        res.send();
    }
}

module.exports = new AuthController();
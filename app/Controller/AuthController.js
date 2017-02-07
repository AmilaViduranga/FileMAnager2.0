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
    this.getId = function(token,res, callback) {
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

    /*
     * upload file sucessfully
     */
    this.Success = function(res) {
        res.write(JSON.stringify({
            status: 200,
            message: 'Successfully uploaded'
        }));
        res.send();
    }

    /*
     * upload file unsucessfull
     */
    this.unSuccess = function(res) {
        res.write(JSON.stringify({
            status: 500,
            message: 'Server error'
        }));
        res.send();
    }

    /*
     * invalid file format or not found
     */

    this.invalidFormat= function(res) {
        res.write(JSON.stringify({
            status: 402,
            message: 'File format is invalid or file not selected'
        }));
        res.send();
    }
}

module.exports = new AuthController();
/**
 * Created by EDI-SD04 on 1/28/2017.
 */
'use strict';

var Connection = require('./Connection');

/*
 * query manager for handle all the queries
 */
function QueryManager() {
    /*
     * query type details
     */
    this.callingType = {
        select: 1,
        update: 2,
        insert: 3
    };

    /*
     * remote query calling location
     *  @query :- the query object contains type and statement
     */
    this.callFileManagerQuery = function (query, callback) {
        if (query.type == this.callingType.select) {
            return Connection.query(query.statement, {type: Connection.QueryTypes.SELECT}).then(function (response) {
                return callback(response);
            }).catch(function(err) {
                console.log(err);
                if(err) {
                    return callback({
                        status: 500,
                        message: "query error"
                    });
                }
            });
        } else if (query.type == this.callingType.insert) {
            return Connection.query(query.statement).then(function (response) {
                return callback(response);
            }).catch(function(err) {
                console.log(err);
                if(err) {
                    return callback({
                        status: 500,
                        message: "query error"
                    });
                }
            });
        } else if (query.type == this.callingType.update) {
            return Connection.query(query.statement, {type: Connection.QueryTypes.UPDATE}).then(function (response) {
                return callback(response);
            }).catch(function (err) {
                console.log(err);
                if(err) {
                    return callback({
                        status: 500,
                        message: "query error"
                    });
                }
            });
        }
    }
}

module.exports = new QueryManager();
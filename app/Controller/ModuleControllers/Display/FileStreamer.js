/**
 * Created by amila on 1/29/17.
 */
var fs = require('fs');

/*
 * stream the file
 */
function FileStream() {
    /*
     * stream the file request by consumer
     */
    this.fileStream = function(path, file, res) {
        return fs.exists(path, function(exists) {
            if(exists) {
                try {
                    res.writeHead(200, {
                        'Content-Type': 'application/octet-stream',
                        'Content-Disposition': 'attachment; filename'+file
                    });
                    return fs.createReadStream(path).pipe(res);
                } catch (err) {
                    console.log(err);
                }
            }
        });
    }
}

module.exports = new FileStream();
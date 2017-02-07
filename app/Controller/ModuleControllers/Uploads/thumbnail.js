/**
 * Created by EDI-SD-06 on 2/6/2017.
 */
'use strict';

var PathManager = require('../../../models/PathManager');
var jimp = require('jimp');


function thumbnail() {


    this.uploadThumbnail = function (source_path, fileName) {
        var thumbnail_path = PathManager.profile_thumbnails + fileName;

        jimp.read(source_path, function (err, image) {
            if (err) throw err;
            image.resize(250, 250)
                .quality(50)
                .write(thumbnail_path);
        });

    }
}

module.exports = new thumbnail();
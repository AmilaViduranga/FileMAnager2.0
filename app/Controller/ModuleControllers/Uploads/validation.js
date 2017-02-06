/**
 * Created by EDI-SD-06 on 2/2/2017.
 */
'use strict';

function validation() {
    var validImageExtensions = ["jpg", "jpeg", "bmp", "png", "svg"];
    var valid = false;

    /*
     * validate image extension
     * */

    this.isImage = function (extention) {
        for (var i = 0; i < validImageExtensions.length; i++) {
            console.log("validate image");
            console.log(extention);
            if (extention == validImageExtensions[i]) {
                valid = true;
                console.log(validImageExtensions[i]);
                break;
            }
        }

        if (!valid) {
            console.log(validImageExtensions[i]);
            return false;
        }

        return true;
    }

    /* 
     * extension convert
     * */

    this.extenConvert = function (exten) {
        var file_exten = 0;
        var extention = [
            ["doc", "application/msword"],
            ["dot", "application/msword"],
            ["docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"],
            ["dotx", "application/vnd.openxmlformats-officedocument.wordprocessingml.template"],
            ["docm", "application/vnd.ms-word.document.macroEnabled"],
            ["dotm", "application/vnd.ms-word.template.macroEnabled"],
            ["xls", "application/vnd.ms-excel"],
            ["xlt", "application/vnd.ms-excel"],
            ["xla", "application/vnd.ms-excel"],
            ["xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
            ["xltx", "application/vnd.openxmlformats-officedocument.spreadsheetml.template"],
            ["xlsm", "application/vnd.ms-excel.sheet.macroEnabled"],
            ["xltm", "application/vnd.ms-excel.template.macroEnabled"],
            ["xlam", "application/vnd.ms-excel.addin.macroEnabled"],
            ["xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled"],
            ["ppt", "application/vnd.ms-powerpoint"],
            ["pot", "application/vnd.ms-powerpoint"],
            ["pps", "application/vnd.ms-powerpoint"],
            ["ppa", "application/vnd.ms-powerpoint"],
            ["pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation"],
            ["potx", "application/vnd.openxmlformats-officedocument.presentationml.template"],
            ["ppsx", "application/vnd.openxmlformats-officedocument.presentationml.slideshow"],
            ["ppam", "application/vnd.ms-powerpoint.addin.macroEnabled"],
            ["pptm", "application/vnd.ms-powerpoint.presentation.macroEnabled"],
            ["potm", "application/vnd.ms-powerpoint.template.macroEnabled"],
            ["ppsm", "application/vnd.ms-powerpoint.slideshow.macroEnabled"],
            ["mdb", "application/vnd.ms-access"],
            ["au", "audio/basic"],
            ["avi", "video/msvideo"],
            ["avi", "video/avi"],
            ["avi", "video/x-msvideo"],
            ["bmp", "image/bmp"],
            ["css", "text/css"],
            ["dtd", "application/xml-dtd"],
            ["exe", "application/octet-stream"],
            ["gif", "image/gif"],
            ["html", "text/html"],
            ["jpg", "image/jpeg"],
            ["midi", "audio/x-midi"],
            ["mp3", "audio/mpeg"],
            ["mpeg", "video/mpeg"],
            ["pdf", "application/pdf"],
            ["png", "image/png"],
            ["qt", "video/quicktime"],
            ["ra", "audio/x-pn-realaudio"],
            ["ra", "audio/vnd.rn-realaudio"],
            ["ram", "audio/x-pn-realaudio"],
            ["ram", "audio/vnd.rn-realaudio"],
            ["svg", "image/svg+xml"],
            ["swf", "application/x-shockwave-flash"],
            ["tar.gz", "`application/x-tar"],
            ["tgz", "application/x-tar"],
            ["txt", "text/plain"],
            ["wav", "audio/wav"],
            ["wav", "audio/x-wav"],
            ["zip", "application/zip"],
            ["zip", "application/x-compressed-zip"]
        ];

        for (var i = 0; i < extention.length; i++) {

            if (exten == extention[i][1]) {
                file_exten = extention[i][0];
                break;
            }

        }

        if (file_exten == 0) {
            var temp = exten.split("/");
            file_exten = temp[1];
        }
        return file_exten;
    }
}

module.exports = new validation();


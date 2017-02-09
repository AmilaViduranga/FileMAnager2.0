/**
 * use as map for all the controllers allocating
 */
var Controllers = {
    UserAuthController: require('./AuthController'),
    DisplayController: {
        ProfileImagesViewController: require('./ModuleControllers/Display/ProfileImagesViewController')
    },
    UploadsController: {
        ProfileImageUploadContoller: require('./ModuleControllers/Uploads/ProfileImageUploadController'),
        SnapUploadController: require('./ModuleControllers/Uploads/snapUploadController'),
        AttachmentUploadController: require('./ModuleControllers/Uploads/attachmentUploadController'),
        ResourceUploadController: require('./ModuleControllers/Uploads/resourceUploadController')
    }

};

module.exports = Controllers;

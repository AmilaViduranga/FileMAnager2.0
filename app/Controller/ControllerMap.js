/**
 * use as map for all the controllers allocating
 */
var Controllers = {
    UserAuthController: require('./AuthController'),
    DisplayController: {
        ProfileImagesViewController: require('./ModuleControllers/Display/ProfileImagesViewController'),
        ResourceViewController: require('./ModuleControllers/Display/ResourcesViewController'),
        SnapViewController: require('./ModuleControllers/Display/SnapViewController'),
        AttachmentViewController : require('./ModuleControllers/Display/AttachmentViewController'),
    },
    UploadsController: {
        ProfileImageUploadContoller: require('./ModuleControllers/Uploads/ProfileImageUploadController'),
        SnapUploadController: require('./ModuleControllers/Uploads/snapUploadController'),
        AttachmentUploadController: require('./ModuleControllers/Uploads/attachmentUploadController'),
        ResourceUploadController: require('./ModuleControllers/Uploads/resourceUploadController')
    }

};

module.exports = Controllers;

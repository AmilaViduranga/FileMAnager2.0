/**
 * Created by User on 9/9/2016.
 * developer: -Kasun
 * use as map for all the controllers allocating
 */
var Controllers = {
    UserAuthController : require('./AuthController'),
    DisplayController: {
        ProfileImagesViewController: require('./ModuleControllers/Display/ProfileImagesViewController')
    },
    UploadsController: {
        ProfileImageUploadContoller: require('./ModuleControllers/Uploads/ProfileImageUploadController'),
        SnapUploadController: require('./ModuleControllers/Uploads/snapUploadController'),
        AttachmentUploadController: require('./ModuleControllers/Uploads/attachmentUploadController'),
        ProfileImagesViewController: require('./ModuleControllers/Display/ProfileImagesViewController'),
        ResourcesViewController : require('./ModuleControllers/Display/ResourcesViewController')
    }

};

module.exports = Controllers;

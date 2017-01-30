/**
 * Created by User on 9/9/2016.
 * developer: -Kasun
 * use as map for all the controllers allocating
 */
var Controllers = {
    UserAuthController : require('./AuthController'),
    DisplayController: {
        ProfileImagesViewController: require('./ModuleControllers/Display/ProfileImagesViewController')
    }
};

module.exports = Controllers;

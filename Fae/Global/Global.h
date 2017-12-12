#import <UIKit/UIKit.h>

#import "FaeAppDelegate.h"
#import "UIButton+BBCBackgroundColor.h"

typedef enum {
    DEVICE_IPHONE_35INCH,
    DEVICE_IPHONE_40INCH,
    DEVICE_IPHONE_47INCH,
    DEVICE_IPHONE_55INCH,
    DEVICE_IPAD,
} DEVICE_TYPE;

typedef enum {
    IOS_8 = 4,
    IOS_7 = 3,
    IOS_6 = 2,
    IOS_5 = 1,
    IOS_4 = 0,
} IOS_VERSION;

typedef enum{
    
    FAE_SEX_NONE,
    FAE_SEX_MALE,
    FAE_SEX_FEMALE,
    
} FAE_SEX;

typedef enum{
    
    FAE_CAMERA_PHOTO,
    FAE_CAMERA_VIDEO,
    
} FAE_CAMERA_MODE;

typedef enum{
    
    FAE_CAMERA_BURST3,
    FAE_CAMERA_BURST5,
    FAE_CAMERA_BURST7,
    
} FAE_CAMERA_BURST;

typedef enum{
    
    FAE_FLASH_AUTO,
    FAE_FLASH_ON,
    FAE_FLASH_OFF,
    
} FAE_FLASH_MODE;

IOS_VERSION gIOSVersion;

DEVICE_TYPE gDeviceType;
CGSize  gScreenSize;
CGFloat gScaleFactor;

CGFloat     gButton_Height;

UIFont*     gInputTextFont;
UIFont*     gTermOfServiceNormalFont;
UIFont*     gTermOfServiceBoldFont;
UIFont*     gNotifyLblFont;
UIFont*     gNotifyLblBoldFont;
UIFont*     gCopyRightFont;
UIFont*     gButtonFont;



UIInterfaceOrientation gDeviceOrientation;

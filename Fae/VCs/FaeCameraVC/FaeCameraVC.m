//
//  FaeCameraVC.h
//  Fae
//
//  Created by Jesse on 3/17/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeCameraVC.h"
#import "ViewUtils.h"
#import "FaeImageViewController.h"
#import "FaeVideoViewController.h"
#import "FaeAppDelegate.h"
#import "Constant.h"
#import "Global.h"
#import "FaeDataKeeper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Resize.h"
#import "UIImage+FixOrientation.h"
#import "MBProgressHUD.h"

#define tCamera_Flash_Auto      1001
#define tCamera_Flash_ON        1002
#define tCamera_Flash_OFF       1003

#define tCamera_Camera_Photo    2001
#define tCamera_Camera_Video    2002

#define tCamera_Burst_3         3001
#define tCamera_Burst_5         3002
#define tCamera_Burst_7         3003

#define tGotIt_Tag_Intro1       4001
#define tGotIt_Tag_Intro2       4002

#define vCamera_Video_Duration_VIDEO_MODE  15
#define vCamera_Video_Duration_PHOTO_MODE  5


//#define EXTRACT_IMAGE_FROM_VIDEO
#define EXTRACT_BURST_IMAGE_FROM_VIDEO

@interface FaeCameraVC ()

@property (strong, nonatomic) LLSimpleCamera *camera;

@property (strong, nonatomic)    IBOutlet UIView*          cameraOverlay;
@property (strong, nonatomic)    IBOutlet UIImageView*     circleOverlay;
@property (strong, nonatomic)    IBOutlet UIImageView*     introImage;

@property (strong, nonatomic)    IBOutlet UIButton*          btn_Back;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Back_Action;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Flash;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Flip;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Flip_Action;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Capture;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_SwitchMode;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Burst;
@property (strong, nonatomic)    IBOutlet UIButton*          btn_Gotit;

@property (strong, nonatomic)   UPStackMenu*                 sm_Flash;
@property (strong, nonatomic)   UPStackMenu*                 sm_CameraMode;
@property (strong, nonatomic)   UPStackMenu*                 sm_CameraBurst;

@property (assign, atomic) FAE_CAMERA_MODE                  fCameraMode;
@property (assign, atomic) FAE_FLASH_MODE                   fFlashMode;
@property (assign, atomic) FAE_CAMERA_BURST                 fBurstMode;

@property (strong, nonatomic)   NSMutableArray*             mCapturedPhotos;
@property (strong, nonatomic)   UITapGestureRecognizer      *tapFocusGesture;

@end

@implementation FaeCameraVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [self initUI];
    
    // Circle Overlay and IntroView Setup
    
    CGFloat     btnFontSize;
    
    if (gDeviceType == DEVICE_IPHONE_35INCH)
    {
        suffixStr = @"4";
        btnFontSize = 17.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        suffixStr = @"5";
        btnFontSize = 17.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_47INCH)
    {
        suffixStr = @"6";
        btnFontSize = 20.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_55INCH)
    {
        suffixStr = @"6p";
        btnFontSize = 22.0f;
    }
    
    [self.introImage setBackgroundColor:RGBA(89, 89, 89, 0.6)];
    
    [self.introImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera_intro_1_%@", suffixStr]]];
    
    [self.btn_Gotit setBackgroundColor:[UIColor clearColor]];
    [self.btn_Gotit.layer setCornerRadius:1.0];
    [self.btn_Gotit.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.btn_Gotit.layer setBorderWidth:2.2];
    self.btn_Gotit.clipsToBounds = YES;
    [self.btn_Gotit.titleLabel setTextColor:[UIColor whiteColor]];
    [self.btn_Gotit.titleLabel setFont:FONT_SEMIBOLD(btnFontSize)];
    
    // Introview Overlay
    
    [self.circleOverlay setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera_overlay_circle_%@", suffixStr]]];
    
    [self.cameraOverlay setFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.introImage.alpha = 0.0f;
    self.btn_Gotit.alpha = 0.0f;
    
    // ----- initialize camera -------- //

    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];

    // attach to a view controller
    [self.camera attachToViewController:self
                              withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];

    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = YES;

    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {

        NSLog(@"Device changed.");

        // device changed, check if flash is available
        if([camera isFlashAvailable])
        {
            if (weakSelf.fCameraMode == FAE_CAMERA_PHOTO)
            {
                [weakSelf.btn_Flash setHidden:NO];
                [weakSelf.sm_Flash setHidden:NO];
                
                [camera updateFlashMode:LLCameraFlashAuto];
            }
            else if (weakSelf.fCameraMode == FAE_CAMERA_VIDEO)
            {
                [weakSelf.btn_Flash setHidden:YES];
                [weakSelf.sm_Flash setHidden:YES];
                
                [camera updateFlashMode:LLCameraFlashOff];
            }
        }
        else
        {
            [weakSelf.btn_Flash setHidden:YES];
            [weakSelf.sm_Flash setHidden:YES];
            
            [camera updateFlashMode:LLCameraFlashOff];
        }
    }];

    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error)
    {
        DLog(@"Camera error: %@", error);

        if([error.domain isEqualToString:LLSimpleCameraErrorDomain])
        {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission)
            {
                DLog(@"We need permission for the camera.\nPlease go to your settings.");
            }
        }
    }];

    [self.view addSubview:self.cameraOverlay];
        
    // ----- camera buttons -------- //
    
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable])
    {
        // button to toggle camera positions
        self.btn_Flip.hidden = NO;
        self.btn_Flip_Action.hidden = NO;
    }
    else
    {
        self.btn_Flip.hidden = YES;
        self.btn_Flip_Action.hidden = YES;
    }
    
    self.tapFocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(previewTapped:)];
    
    self.tapFocusGesture.numberOfTapsRequired = 1;
    [self.tapFocusGesture setDelaysTouchesEnded:NO];
    for (UIGestureRecognizer *gesture in self.camera.gestureRecognizers) {
        [self.view addGestureRecognizer:gesture];
    }
    [self.view addGestureRecognizer:self.tapFocusGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (isLoaded == YES)
    {
        return;
    }
    
    isLoaded = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self initUI];
        
    });
    
    flashContainer = [[UIView alloc] initWithFrame:CGRectMake(self.btn_Flash.frame.origin.x - 5, self.btn_Flash.frame.origin.y - 5, self.btn_Flash.frame.size.width+10, self.btn_Flash.frame.size.height+10)];
    
    [flashContainer setBackgroundColor:[UIColor clearColor]];
    
    cameraModeContainer = [[UIView alloc] initWithFrame:CGRectMake(self.btn_SwitchMode.frame.origin.x - 5, self.btn_SwitchMode.frame.origin.y+self.btn_SwitchMode.frame.size.height, self.btn_SwitchMode.frame.size.width+10, (self.btn_SwitchMode.frame.size.width + 10) * (31.0f/30.0f))];
    
    [cameraModeContainer setBackgroundColor:[UIColor clearColor]];
    
    burstContainer = [[UIView alloc] initWithFrame:CGRectMake(self.btn_Burst.frame.origin.x - 5, self.btn_Burst.frame.origin.y + 5, self.btn_Burst.frame.size.width+10, self.btn_Burst.frame.size.height+10)];
    
    [burstContainer setBackgroundColor:[UIColor clearColor]];
    
    
    // Install Flash Menus
    self.fFlashMode = FAE_FLASH_AUTO;
    
    [self installFlashMenus];
    
    // Install Camera/Photo Menus
    self.fCameraMode = FAE_CAMERA_PHOTO;
    
    [self installCameraMenus];
    
    // Install Burst Menus
    self.fBurstMode = FAE_CAMERA_BURST3;
    
    [self installBurstMenus];
    
    if ([[FaeDataKeeper sharedInstance] passedInroView:1] == NO)
    {
        [self showIntro1];
        self.btn_Gotit.tag = tGotIt_Tag_Intro1;
    }
    else
    {
        if ([[FaeDataKeeper sharedInstance] passedInroView:2] == NO)
        {
            [self showIntro2];
            self.btn_Gotit.tag = tGotIt_Tag_Intro2;
        }
    }
}

- (void)initUI
{
    if (gDeviceType == DEVICE_IPHONE_35INCH)
    {
        btnFlash_LeftPadding.constant = 16.0f;
        btnFlash_TopPadding.constant = 10.0f;
        btnFlash_Width.constant = 16.0f;
        
        btnFlip_RightPadding.constant = 15.5f;
        btnFlip_TopPadding.constant = 10.0f;
        btnFlip_Width.constant = 23.f;
        
        btnMode_RightPadding.constant = 15.4f;
        btnMode_BottomPadding.constant = 27.4f;
        btnMode_Width.constant = 22.5f;
        
        btnBurst_RightPadding.constant = 23.5f;
        btnBurst_BottomPadding.constant = 27.3;
        btnBurst_Width.constant = 22.4f;
        
        btnCapture_Width.constant = 56.4f;
        btnCapture_BottomPadding.constant = 11.0f;
        
        btnGotit_TopPadding.constant = 226.5f;
        btnGotit_Height.constant = 41.7f;
        btnGotit_Width.constant = 125.2f;
        
        btnBack_Width.constant = 13.0f;
        btnBack_LeftPadding.constant = 16.0f;
        btnBack_BottomPadding.constant = 28.0f;
        
        redCircleDiameter = 44.1f;
        redBarThicknees = 2.5f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        btnFlash_LeftPadding.constant = 16.0f;
        btnFlash_TopPadding.constant = 10.0f;
        btnFlash_Width.constant = 16.0f;
        
        btnFlip_RightPadding.constant = 15.5f;
        btnFlip_TopPadding.constant = 10.0f;
        btnFlip_Width.constant = 23.f;
        
        btnMode_RightPadding.constant = 15.4f;
        btnMode_BottomPadding.constant = 27.4f;
        btnMode_Width.constant = 22.5f;
        
        btnBurst_RightPadding.constant = 24.0f;
        btnBurst_BottomPadding.constant = 27.06;
        btnBurst_Width.constant = 22.4f;
        
        btnCapture_Width.constant = 56.0f;
        btnCapture_BottomPadding.constant = 11.0f;
        
        btnGotit_TopPadding.constant = 303.25f;
        btnGotit_Height.constant = 41.7f;
        btnGotit_Width.constant = 125.2f;
        
        btnBack_Width.constant = 13.0f;
        btnBack_LeftPadding.constant = 16.0f;
        btnBack_BottomPadding.constant = 28.5f;
        
        redCircleDiameter = 42.0f;
        redBarThicknees = 3.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_47INCH)
    {
        btnFlash_LeftPadding.constant =  19.0f;
        btnFlash_TopPadding.constant = 11.8f;
        btnFlash_Width.constant = 17.2f;
        
        btnFlip_RightPadding.constant = 18.3f;
        btnFlip_TopPadding.constant = 11.8f;
        btnFlip_Width.constant = 27.f;
        
        btnMode_RightPadding.constant = 17.38f;
        btnMode_BottomPadding.constant = 32.5f;
        btnMode_Width.constant = 27.0f;
        
        btnBurst_RightPadding.constant = 28.0f;
        btnBurst_BottomPadding.constant = 31.7f;
        btnBurst_Width.constant = 26.27f;
        
        btnCapture_Width.constant = 66.0f;
        btnCapture_BottomPadding.constant = 12.7f;
        
        btnGotit_TopPadding.constant = 355.25f;
        btnGotit_Height.constant = 48.94f;
        btnGotit_Width.constant = 146.74f;
        
        btnBack_Width.constant = 16.0f;
        btnBack_LeftPadding.constant = 19.0f;
        btnBack_BottomPadding.constant = 32.4f;
        
        redCircleDiameter = 52.1f;
        redBarThicknees = 3.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_55INCH)
    {
        btnFlash_LeftPadding.constant =  21.0f;
        btnFlash_TopPadding.constant = 13.0f;
        btnFlash_Width.constant = 19.0f;
        
        btnFlip_RightPadding.constant = 20.0f;
        btnFlip_TopPadding.constant = 13.0f;
        btnFlip_Width.constant = 30.f;
        
        btnMode_RightPadding.constant = 20.0f;
        btnMode_BottomPadding.constant = 37.0f;
        btnMode_Width.constant = 29.0f;
        
        btnBurst_RightPadding.constant = 31.0f;
        btnBurst_BottomPadding.constant = 35.0f;
        btnBurst_Width.constant = 29.0f;
        
        btnCapture_Width.constant = 75.0f;
        btnCapture_BottomPadding.constant = 13.0f;
        
        btnGotit_TopPadding.constant = 392.0f;
        btnGotit_Height.constant = 54.0f;
        btnGotit_Width.constant = 162.0f;
        
        btnBack_Width.constant = 17.0f;
        btnBack_LeftPadding.constant = 21.0f;
        btnBack_BottomPadding.constant = 36.0f;
        
        redCircleDiameter = 57.0f;
        redBarThicknees = 3.3f;
    }
    
    [self.btn_Burst setHidden:YES];
    [self.sm_CameraBurst setHidden:YES];
    
    [self.view layoutIfNeeded];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)control
{
    NSLog(@"Segment value changed!");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // start the camera
    [self.camera start];
    
    // Show auto focus pointer
    
    double delayInSeconds = 0.7f;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
//        [self.camera setFocusOnSelectedPoint:self.view.center];
        
    });
}

/* camera button methods */

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/* other lifecycle methods */

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.camera.view.frame = self.view.contentBounds;

    [self.view layoutSubviews];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)onBack:(id)sender
{
    if (self.fCameraMode == FAE_CAMERA_PHOTO)
    {
        [self.camera performSelector:@selector(stop) withObject:nil afterDelay:0.2];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (self.fCameraMode == FAE_CAMERA_VIDEO)
    {
        if(!self.camera.isRecording)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
    }
}

- (IBAction)onGotit:(id)sender
{
    if (self.btn_Gotit.tag == tGotIt_Tag_Intro1)
    {
        [[FaeDataKeeper sharedInstance] updateIntroViewed:1];
    }
    else if (self.btn_Gotit.tag == tGotIt_Tag_Intro2)
    {
        [[FaeDataKeeper sharedInstance] updateIntroViewed:2];
    }
    
    [self closeIntro];
}

- (IBAction)onFlash:(id)sender
{
    DLog(@"Will update the flash mode between Auto, On and Off");
    
    switch (self.fFlashMode) {
        case FAE_FLASH_AUTO:
        {
            BOOL done = [self.camera updateFlashMode:LLCameraFlashAuto];
            
            if(done)
            {
                DLog(@"Camera Flash Mode : %@", @"Auto");
            }
        }
            break;
            
        case FAE_FLASH_ON:
        {
            BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
            
            if(done)
            {
                DLog(@"Camera Flash Mode : %@", @"On");
            }
        }
            break;
            
        case FAE_FLASH_OFF:
        {
            BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
            
            if(done)
            {
                DLog(@"Camera Flash Mode : %@", @"Off");
            }
        }
            break;
    }
}

- (IBAction)onFlip:(id)sender
{
    [self.camera togglePosition];
 
    if (self.camera.position == LLCameraPositionFront)
    {
        // show the font icon
        
        [self.btn_Flip setImage:[UIImage imageNamed:@"camera_flip_rear"] forState:UIControlStateNormal];
    }
    else if (self.camera.position == LLCameraPositionRear)
    {
        // show the back icon
        [self.btn_Flip setImage:[UIImage imageNamed:@"camera_flip_front"] forState:UIControlStateNormal];
    }
    
    DLog(@"%d", (int)self.camera.position);
}

- (IBAction)onCapture:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    self.mCapturedPhotos = [[NSMutableArray alloc] init];
    
    if (self.fCameraMode == FAE_CAMERA_PHOTO)
    {
        // We can take photo
        
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if(!error) {
                
                // We should stop the camera, we are opening a new vc, thus we don't need it anymore.
                // This is important, otherwise you may experience memory crashes.
                // Camera is started again at viewWillAppear after the user comes back to this view.
                // I put the delay, because in iOS9 the shutter sound gets interrupted if we call it directly.
                
                NSData *jpegData =UIImageJPEGRepresentation(image, 0.4f);
                
                NSString* singlePhotoPath = [NSString stringWithFormat:@"%@/single", [FCFileManager pathForDocumentsDirectory]];
                
                if (![FCFileManager existsItemAtPath:singlePhotoPath])
                {
                    [FCFileManager createDirectoriesForPath:singlePhotoPath];
                }
                
                NSString* individualName = [NSString stringWithFormat:@"single_profile.jpg"];
                
                //Add the file name
                NSString *filePath = [singlePhotoPath stringByAppendingPathComponent:individualName];
                
                [weakSelf.mCapturedPhotos addObject:filePath];
                
                DLog(@"Single Image Path : %@", filePath);
                
                //Write the file
                [jpegData writeToFile:filePath
                           atomically:YES];
                
                [camera performSelector:@selector(stop) withObject:nil afterDelay:0.2];
                
                UIImage* singleImg = [UIImage imageWithContentsOfFile:filePath];
                
                FaeImageViewController *imageVC = [[FaeImageViewController alloc] initWithImage:singleImg];
                [weakSelf presentViewController:imageVC animated:NO completion:nil];
            }
            else {
                NSLog(@"An error has occured: %@", error);
            }
        } exactSeenImage:YES];
    }
    else if (self.fCameraMode == FAE_CAMERA_VIDEO)
    {
        
#ifdef EXTRACT_BURST_IMAGE_FROM_VIDEO
        
        [self doCaptureBurstImageFromVideo];
        
        [self performSelector:@selector(doCaptureBurstImageFromVideo) withObject:nil afterDelay:1 * remainingBurstCount];
        
#else
        
        // We can take a video or burst photos
        // If this is long press, then it will be taking a video
        // But this is short touch, then it will be taking burst photos
        
        // This is taking a Burst Photos
        
        DLog(@"Taking Burst Photos");
        
        NSString* burstPhotoPath = [NSString stringWithFormat:@"%@/burst", [FCFileManager pathForDocumentsDirectory]];
        
        // Clean files
        
        NSLog(@"\n/***********************************/\n");
        
        NSArray* fileList = [FCFileManager listFilesInDirectoryAtPath:burstPhotoPath];
        
        NSLog(@"%@", fileList);
        
        NSLog(@"\n/***********************************/\n");
        
        [FCFileManager removeFilesInDirectoryAtPath:burstPhotoPath];
        
        fileList = [FCFileManager listFilesInDirectoryAtPath:burstPhotoPath];
        
        NSLog(@"%@", fileList);
        
        [self.camera updateFlashMode:LLCameraFlashOff];
        
        //        burstTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
        burstTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timedPhotoFire:)
                                                    userInfo:nil
                                                     repeats:YES];
        [burstTimer fire]; // Start taking pictures right away.
        
#endif
        
    }
}

- (IBAction)onSwithMode:(id)sender
{
    if (self.fCameraMode == FAE_CAMERA_PHOTO)
    {
        // Will hide the burst buttons
        
        if (self.btn_Burst)
        {
            [self.btn_Burst setHidden:YES];
        }
        
        if (burstContainer)
        {
            [burstContainer setHidden:YES];
        }
        
        if (self.sm_CameraBurst)
        {
            [self.sm_CameraBurst setHidden:YES];
        }
        
        // Will show the Flash Buttons
        if (self.btn_Flash)
        {
            [self.btn_Flash setHidden:NO];
        }
        
        if (flashContainer)
        {
            [flashContainer setHidden:NO];
        }
        
        if (self.sm_Flash)
        {
            [self.sm_Flash setHidden:NO];
        }
        
        // Remove any obverlay from Capture button
        
        [recordTimer invalidate];
        
        recordTimer = Nil;
        
        if (redOutlineView)
        {
            [redOutlineView stop];
        }
        
        // Remove Red circle view
        
        if ([videoCircleView superview])
        {
            [videoCircleView removeFromSuperview];
        }
        
        if ([redOutlineView superview])
        {
            [redOutlineView removeFromSuperview];
        }
        
        // Recover Capture button's Image
        
        [self.btn_Capture setImage:[UIImage imageNamed:@"camera_capture"] forState:UIControlStateNormal];
    }
    else if (self.fCameraMode == FAE_CAMERA_VIDEO)
    {
        // If we did not show the Intro2, we will show for now.
        
        if ([[FaeDataKeeper sharedInstance] passedInroView:2] == NO)
        {
            self.btn_Gotit.tag = tGotIt_Tag_Intro2;
            
            [self showIntro2];
        }
        
        // Will show the burst buttons
        
        if (self.btn_Burst)
        {
            [self.btn_Burst setHidden:NO];
        }
        
        if (burstContainer)
        {
            [burstContainer setHidden:NO];
        }
        
        if (self.sm_CameraBurst)
        {
            [self.sm_CameraBurst setHidden:NO];
        }
        
        // Will Hide the Flash Buttons
        
        // Will show the Flash Buttons
        if (self.btn_Flash)
        {
            [self.btn_Flash setHidden:YES];
        }
        
        if (flashContainer)
        {
            [flashContainer setHidden:YES];
        }
        
        if (self.sm_Flash)
        {
            [self.sm_Flash setHidden:YES];
        }
        
//        // Add Gesture to take the video
//        
//        for (UIGestureRecognizer *recognizer in self.btn_Capture.gestureRecognizers)
//        {
//            [self.btn_Capture removeGestureRecognizer:recognizer];
//        }
//        
//        pressLongGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(takeVideo:)];
//        
//        [self.btn_Capture addGestureRecognizer:pressLongGesture];
    }
    
    // Add Gesture to take the video
    
    for (UIGestureRecognizer *recognizer in self.btn_Capture.gestureRecognizers)
    {
        [self.btn_Capture removeGestureRecognizer:recognizer];
    }
    
    pressLongGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(takeVideo:)];
    
    [self.btn_Capture addGestureRecognizer:pressLongGesture];
}

- (IBAction)onBurstInterval:(id)sender
{
    switch (self.fBurstMode) {
        case FAE_CAMERA_BURST3:
            remainingBurstCount = 3;
            break;
            
        case FAE_CAMERA_BURST5:
            remainingBurstCount = 5;
            break;
            
        case FAE_CAMERA_BURST7:
            remainingBurstCount = 7;
            break;
    }
}

- (void)takeVideo : (UILongPressGestureRecognizer*) gesture
{
//    if (self.fCameraMode == FAE_CAMERA_VIDEO)
    {
        NSInteger state = gesture.state;
        
        switch (state) {
            case UIGestureRecognizerStateChanged: break;
            case UIGestureRecognizerStateBegan:
            {
                // Add Red circle view
                
                if (videoCircleView)
                {
                    videoCircleView = Nil;
                }
                
                videoCircleView = [[UIView alloc] initWithFrame:CGRectMake(self.btn_Capture.frame.origin.x, self.btn_Capture.frame.origin.y, self.btn_Capture.frame.size.width, self.btn_Capture.frame.size.height)];
                
                [self circleFilledWithOutline:videoCircleView
                                     diameter:redCircleDiameter
                                    thickness:0.0f
                                    fillColor:RED_COLOR
                                 outlineColor:RED_COLOR];
                
                [self.cameraOverlay addSubview:videoCircleView];
                
                if (redOutlineView)
                {
                    redOutlineView = Nil;
                }
                
                redOutlineView = [[JWGCircleCounter alloc] initWithFrame:CGRectMake(self.btn_Capture.frame.origin.x, self.btn_Capture.frame.origin.y, self.btn_Capture.frame.size.width, self.btn_Capture.frame.size.height)];
                
                redOutlineView.circleColor = [UIColor whiteColor];
                redOutlineView.circleBackgroundColor = RED_COLOR;
                redOutlineView.circleFillColor = [UIColor clearColor];
                redOutlineView.circleTimerWidth = redBarThicknees;
                
                if (self.fCameraMode == FAE_CAMERA_VIDEO)
                {
                    [redOutlineView startWithSeconds:vCamera_Video_Duration_VIDEO_MODE];
                    
                    remainingTime = vCamera_Video_Duration_VIDEO_MODE;
                }
                else if (self.fCameraMode == FAE_CAMERA_PHOTO)
                {
                    [redOutlineView startWithSeconds:vCamera_Video_Duration_PHOTO_MODE];
                    
                    remainingTime = vCamera_Video_Duration_PHOTO_MODE;
                }
                
                [self.cameraOverlay addSubview:redOutlineView];
                
                [self.btn_Capture setImage:Nil forState:UIControlStateNormal];
                
                // Start timer
                
                recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                               target:self
                                                             selector:@selector(observeTimer)
                                                             userInfo:Nil
                                                              repeats:YES];
                
                [self.camera updateFlashMode:LLCameraFlashOff];
                
                DLog(@"Start Capturing");
                
                [self doCaptureVideo];
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                // Stop timer
                
                [recordTimer invalidate];
                
                recordTimer = Nil;
                
                if (redOutlineView)
                {
                    [redOutlineView stop];
                }
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    // Remove Red circle view
                    
                    if ([videoCircleView superview])
                    {
                        [videoCircleView removeFromSuperview];
                    }
                    
                    if ([redOutlineView superview])
                    {
                        [redOutlineView removeFromSuperview];
                    }
                    
                    // Recover Capture button's Image
                    
                    [self.btn_Capture setImage:[UIImage imageNamed:@"camera_capture"] forState:UIControlStateNormal];
                    
                    [self onFlash:Nil];
                    
                    [self doCaptureVideo];
                    
                });
                
                DLog(@"End Capturing");
                
                
            }
                break;
        }
    }
}

- (void) observeTimer
{
    remainingTime = remainingTime - 1;
    
    DLog(@"%d", (int)remainingTime);
    
    if (remainingTime == 0)
    {
        // Stop timer
        
        [recordTimer invalidate];
        
        recordTimer = Nil;
        
        if (redOutlineView)
        {
            [redOutlineView stop];
        }
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            // Remove Red circle view
            
            if ([videoCircleView superview])
            {
                [videoCircleView removeFromSuperview];
            }
            
            if ([redOutlineView superview])
            {
                [redOutlineView removeFromSuperview];
            }
            
            // Recover Capture button's Image
            
            [self.btn_Capture setImage:[UIImage imageNamed:@"camera_capture"] forState:UIControlStateNormal];
            
            [self doCaptureVideo];
            
        });
    }
    else
    {
        
    }
}

- (void)timedPhotoFire:(NSTimer *)timer
{
    __weak typeof(self) weakSelf = self;
    
    if (timer == burstTimer)
    {
        [self.camera updateFlashMode:LLCameraFlashOff];
        
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error)
         {
             if(!error)
             {
                 if (image)
                 {
                     NSData *jpegData =UIImageJPEGRepresentation(image, 1.0f);
                     
                     NSString* burstPhotoPath = [NSString stringWithFormat:@"%@/burst", [FCFileManager pathForDocumentsDirectory]];
                     
                     if (![FCFileManager existsItemAtPath:burstPhotoPath])
                     {
                         [FCFileManager createDirectoriesForPath:burstPhotoPath];
                     }
                     
                     NSString* individualName = [NSString stringWithFormat:@"burst_profile_%d.jpg", (int)remainingBurstCount];
                     
                     //Add the file name
                     NSString *filePath = [burstPhotoPath stringByAppendingPathComponent:individualName];
                     
                     [self.mCapturedPhotos addObject:filePath];
                     
                     DLog(@"Image Path : %@", filePath);
                     
                     //Write the file
                     [jpegData writeToFile:filePath
                                atomically:YES];
                     
                     // Restart Capturing
                     
                     remainingBurstCount = remainingBurstCount - 1;
                     
                     DLog(@"Remaining Burst Photos : %d", (int)remainingBurstCount);
                     
                     if (remainingBurstCount == 0)
                     {
                         [camera performSelector:@selector(stop) withObject:nil afterDelay:0.2];
                         
                         if ([burstTimer isValid])
                         {
                             [burstTimer invalidate];
                             burstTimer = Nil;
                         }
                         
                         // Restore the Counter again.
                         
                         [self onBurstInterval:Nil];
                         [self onFlash:Nil];
                         
                         // Will show the Image View As before.
                         
                         FaeImageViewController *imageVC = [[FaeImageViewController alloc] initWithImagePaths:weakSelf.mCapturedPhotos];
                         
                         [weakSelf presentViewController:imageVC animated:NO completion:nil];
                         
                     }
                 }
             }
             else
             {
                 NSLog(@"An error has occured: %@", error);
             }
         } exactSeenImage:YES];
    }
}

- (void) circleFilledWithOutline:(UIView*)circleView
                        diameter:(CGFloat)diameter
                      thickness :(CGFloat)thickness
                       fillColor:(UIColor*)fillColor
                    outlineColor:(UIColor*)outlinecolor
{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    float width = circleView.frame.size.width;
    float height = circleView.frame.size.height;
    
    [circleLayer setBounds:CGRectMake(thickness, thickness, width-thickness, height-thickness)];
    [circleLayer setPosition:CGPointMake(width/2, height/2)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((width - diameter)/2, (width - diameter)/2, diameter, diameter)];
    
    [circleLayer setPath:[path CGPath]];
    
    [circleLayer setFillColor:fillColor.CGColor];
    [circleLayer setStrokeColor:outlinecolor.CGColor];
    
    [circleLayer setLineWidth:2.0f];
    [[circleView layer] addSublayer:circleLayer];
}

- (void) doCaptureVideo
{
    if(!self.camera.isRecording)
    {
        self.btn_Flip.hidden = YES;
        self.btn_Flip_Action.hidden = YES;
        
        // start recording
        NSURL *outputURL = [[[self applicationDocumentsDirectory]
                             URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
        
        [self.camera startRecordingWithOutputUrl:outputURL];
        
    }
    else
    {
        self.btn_Flip.hidden = NO;
        self.btn_Flip_Action.hidden = NO;
        
        [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error)
         {
             // Testing to extract the thumbnail images from the video
#ifdef EXTRACT_IMAGE_FROM_VIDEO
             
             MPMoviePlayerController *movie = [[MPMoviePlayerController alloc]
                                               initWithContentURL:outputFileUrl];
             
             NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]                                                   forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
             
             AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:outputFileUrl options:opts];
             
             int64_t seconds = urlAsset.duration.value / urlAsset.duration.timescale;
             
             NSMutableArray* imageFramePath = [[NSMutableArray alloc] init];
             
             NSString* videoPhotoPath = [NSString stringWithFormat:@"%@/video", [FCFileManager pathForDocumentsDirectory]];
             
             if (![FCFileManager existsItemAtPath:videoPhotoPath])
             {
                 [FCFileManager createDirectoriesForPath:videoPhotoPath];
             }
             
             NSLog(@"\n/***********************************/\n");
             
             NSArray* fileList = [FCFileManager listFilesInDirectoryAtPath:videoPhotoPath];
             
             NSLog(@"%@", fileList);
             
             NSLog(@"\n/***********************************/\n");
             
             [FCFileManager removeFilesInDirectoryAtPath:videoPhotoPath];
             
             fileList = [FCFileManager listFilesInDirectoryAtPath:videoPhotoPath];
             
             NSLog(@"%@", fileList);
             
             float step = seconds / 10.0f;
             
             for (float pointer = step ; pointer < seconds ; pointer = pointer + step )
             {
                 UIImage *frameImage = [movie thumbnailImageAtTime:pointer
                                                        timeOption:MPMovieTimeOptionExact];
                 
                 NSString* individualName = [NSString stringWithFormat:@"video_profile_%.1f.jpg", pointer];
                 
                 //Add the file name
                 NSString *filePath = [videoPhotoPath stringByAppendingPathComponent:individualName];
                 
                 [imageFramePath addObject:filePath];
                 
                 DLog(@"Image Path : %@", filePath);
                 
                 NSData *jpegData =UIImageJPEGRepresentation(frameImage, 0.4f);
                 
                 //Write the file
                 [jpegData writeToFile:filePath
                            atomically:YES];
             }
             
             FaeImageViewController *imageVC = [[FaeImageViewController alloc] initWithImagePaths:imageFramePath];
             
             [self presentViewController:imageVC animated:NO completion:nil];
             
#else
             
             FaeVideoViewController *vc = [[FaeVideoViewController alloc] initWithVideoUrl:outputFileUrl];
             
             [self.navigationController pushViewController:vc animated:YES];
             
#endif
             
         }];
    }
}

- (void) doCaptureBurstImageFromVideo
{
    if(!self.camera.isRecording)
    {
        self.btn_Flip.hidden = YES;
        self.btn_Flip_Action.hidden = YES;
        
        // start recording
        NSURL *outputURL = [[[self applicationDocumentsDirectory]
                             URLByAppendingPathComponent:@"burstVideo"] URLByAppendingPathExtension:@"mov"];
        
        [self.camera startRecordingWithOutputUrl:outputURL];
        
    }
    else
    {
        self.btn_Flip.hidden = NO;
        self.btn_Flip_Action.hidden = NO;
        
        [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error)
         {
             // Testing to extract the thumbnail images from the video
#ifdef EXTRACT_BURST_IMAGE_FROM_VIDEO
             
             [MBProgressHUD hideAllHUDsForView:[FaeAppDelegate sharedDelegate].window animated:NO];
             [MBProgressHUD showHUDAddedTo:[FaeAppDelegate sharedDelegate].window animated:YES];
             
             MPMoviePlayerController *movie = [[MPMoviePlayerController alloc]
                                               initWithContentURL:outputFileUrl];
             
             NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]                                                   forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
             
             AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:outputFileUrl options:opts];
             
             DLog(@"%lld - %d", urlAsset.duration.value, urlAsset.duration.timescale);
             
             float seconds = (float)urlAsset.duration.value / (float)urlAsset.duration.timescale;
             
             NSMutableArray* imageFramePath = [[NSMutableArray alloc] init];
             
             /*
              
              
              
              NSString* individualName = [NSString stringWithFormat:@"burst_profile_%d.jpg", (int)remainingBurstCount];
              
              */
             
             NSString* burstPhotoPath = [NSString stringWithFormat:@"%@/burst", [FCFileManager pathForDocumentsDirectory]];
             
             if (![FCFileManager existsItemAtPath:burstPhotoPath])
             {
                 [FCFileManager createDirectoriesForPath:burstPhotoPath];
             }
             
             NSLog(@"\n/***********************************/\n");
             
             NSArray* fileList = [FCFileManager listFilesInDirectoryAtPath:burstPhotoPath];
             
             NSLog(@"%@", fileList);
             
             NSLog(@"\n/***********************************/\n");
             
             [FCFileManager removeFilesInDirectoryAtPath:burstPhotoPath];
             
             fileList = [FCFileManager listFilesInDirectoryAtPath:burstPhotoPath];
             
             NSLog(@"%@", fileList);
             
             float step = seconds / remainingBurstCount;
             
             for (float pointer = step ; pointer <= seconds ; pointer = pointer + step )
             {
                 UIImage *frameImage = [movie thumbnailImageAtTime:pointer
                                                        timeOption:MPMovieTimeOptionExact];
                 
                 NSString* individualName = [NSString stringWithFormat:@"burst_profile_%3f.jpg", pointer];
                 
                 //Add the file name
                 NSString *filePath = [burstPhotoPath stringByAppendingPathComponent:individualName];
                 
                 [imageFramePath addObject:filePath];
                 
                 DLog(@"Image Path : %@", filePath);
                 
                 NSData *jpegData =UIImageJPEGRepresentation(frameImage, 0);
                 
                 //Write the file
                 [jpegData writeToFile:filePath
                            atomically:YES];
             }
             
             [MBProgressHUD hideAllHUDsForView:[FaeAppDelegate sharedDelegate].window animated:NO];
             
             if ([imageFramePath count])
             {
                 FaeImageViewController *imageVC = [[FaeImageViewController alloc] initWithImagePaths:imageFramePath];
                 
                 [self presentViewController:imageVC animated:NO completion:nil];
             }
             
#else
             
             FaeVideoViewController *vc = [[FaeVideoViewController alloc] initWithVideoUrl:outputFileUrl];
             
             [self.navigationController pushViewController:vc animated:YES];
             
#endif
             
         }];
    }
}

#pragma mark - Utility Function

- (void)showIntro1
{
    [self.cameraOverlay bringSubviewToFront:self.introImage];
    [self.cameraOverlay bringSubviewToFront:self.btn_Gotit];
    [self.cameraOverlay bringSubviewToFront:self.btn_Back];
    [self.cameraOverlay bringSubviewToFront:self.btn_Back_Action];
    
    
    [self.introImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera_intro_1_%@", suffixStr]]];
    [self.introImage setAlpha:1.0f];
    [self.btn_Gotit setAlpha:1.0f];
    
    [self.sm_Flash setUserInteractionEnabled:NO];
    [self.btn_Flip_Action setUserInteractionEnabled:NO];
    [self.btn_Capture setUserInteractionEnabled:NO];
    [self.sm_CameraMode setUserInteractionEnabled:NO];
    [self.sm_CameraBurst setUserInteractionEnabled:NO];
}

- (void)showIntro2
{
    [self.cameraOverlay bringSubviewToFront:self.introImage];
    [self.cameraOverlay bringSubviewToFront:self.btn_Gotit];
    [self.cameraOverlay bringSubviewToFront:self.btn_Back];
    [self.cameraOverlay bringSubviewToFront:self.btn_Back_Action];
    
    [self.introImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera_intro_2_%@", suffixStr]]];
    [self.introImage setAlpha:1.0f];
    [self.btn_Gotit setAlpha:1.0f];
    
    [self.sm_Flash setUserInteractionEnabled:NO];
    [self.btn_Flip_Action setUserInteractionEnabled:NO];
    [self.btn_Capture setUserInteractionEnabled:NO];
    [self.sm_CameraMode setUserInteractionEnabled:NO];
    [self.sm_CameraBurst setUserInteractionEnabled:NO];
}

- (void)closeIntro
{
    // Will hide the introview
    
    self.introImage.alpha = 1.0f;
    self.btn_Gotit.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.introImage.alpha = 0.0f;
                         self.btn_Gotit.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                        
                         self.introImage.alpha = 0.0f;
                         self.btn_Gotit.alpha = 0.0f;
                         
                         [self.sm_Flash setUserInteractionEnabled:YES];
                         [self.btn_Flip_Action setUserInteractionEnabled:YES];
                         [self.btn_Capture setUserInteractionEnabled:YES];
                         [self.sm_CameraMode setUserInteractionEnabled:YES];
                         [self.sm_CameraBurst setUserInteractionEnabled:YES];

                         
                     }];
}

#pragma Stack Menu Function

- (void)installFlashMenus
{
    if (self.sm_Flash)
    {
        [self.sm_Flash removeFromSuperview];
    }
    
    self.sm_Flash = [[UPStackMenu alloc] initWithContentView:flashContainer];
    
    [self.sm_Flash setCenter:self.btn_Flash.center];
    
    [self.sm_Flash setDelegate:self];
    
    UPStackMenuItem *firstFlash = Nil;
    UPStackMenuItem *secondFlash = Nil;
    
    switch (self.fFlashMode) {
        case FAE_FLASH_AUTO:
        {
            firstFlash =
            [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_on"]
                                          fillSize:flashContainer.frame.size
                                  highlightedImage:nil
                                             title:@""];
            firstFlash.tag = tCamera_Flash_ON;
            
            secondFlash = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_off"]
                                                        fillSize:flashContainer.frame.size
                                                highlightedImage:nil
                                                           title:@""];
            secondFlash.tag = tCamera_Flash_OFF;
        }
            break;
            
        case FAE_FLASH_ON:
        {
            firstFlash =
            [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_auto"]
                                          fillSize:flashContainer.frame.size
                                  highlightedImage:nil
                                             title:@""];
            
            firstFlash.tag = tCamera_Flash_Auto;
            
            secondFlash = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_off"]
                                                        fillSize:flashContainer.frame.size
                                                highlightedImage:nil
                                                           title:@""];
            secondFlash.tag = tCamera_Flash_OFF;
        }
            break;
            
        case FAE_FLASH_OFF:
        {
            firstFlash =
            [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_auto"]
                                          fillSize:flashContainer.frame.size
                                  highlightedImage:nil
                                             title:@""];
            
            firstFlash.tag = tCamera_Flash_Auto;
            
            secondFlash =
            [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_flash_on"]
                                          fillSize:flashContainer.frame.size
                                  highlightedImage:nil
                                             title:@""];
            
            secondFlash.tag = tCamera_Flash_ON;
        }
            break;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:firstFlash, secondFlash, nil];
    
    [self.sm_Flash setAnimationType:UPStackMenuAnimationType_progressive];
    [self.sm_Flash setStackPosition:UPStackMenuStackPosition_down];
    [self.sm_Flash setOpenAnimationDuration:.4];
    [self.sm_Flash setCloseAnimationDuration:.4];
    
    [self.sm_Flash addItems:items];
    
    [self.cameraOverlay addSubview:self.sm_Flash];
    
    [self updateFlashIcon];
    
    for (UPStackMenuItem* item in self.sm_Flash.items)
    {
        [item setHidden:YES];
    }
    
}

- (void)installCameraMenus
{
    if (self.sm_CameraMode)
    {
        [self.sm_CameraMode removeFromSuperview];
    }
    
    self.sm_CameraMode = [[UPStackMenu alloc] initWithContentView:cameraModeContainer];
    
    CGPoint centerPoint = self.btn_SwitchMode.center;
    
    CGFloat offset = self.btn_SwitchMode.frame.size.height - self.btn_SwitchMode.frame.size.width;
    
    CGPoint fixedCenter = CGPointMake(centerPoint.x, centerPoint.y + (offset / 2));
    
    [self.sm_CameraMode setCenter:fixedCenter];
    
    [self.sm_CameraMode setDelegate:self];
    
    UPStackMenuItem *firstMode = Nil;
    
    if (self.fCameraMode == FAE_CAMERA_PHOTO)
    {
        firstMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_video"]
                                      fillSize:cameraModeContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        firstMode.tag = tCamera_Camera_Video;
    }
    else if (self.fCameraMode == FAE_CAMERA_VIDEO)
    {
        firstMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_photo"]
                                      fillSize:cameraModeContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        firstMode.tag = tCamera_Camera_Photo;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:firstMode, nil];
    
    [self.sm_CameraMode setAnimationType:UPStackMenuAnimationType_progressive];
    [self.sm_CameraMode setStackPosition:UPStackMenuStackPosition_up];
    [self.sm_CameraMode setOpenAnimationDuration:.3];
    [self.sm_CameraMode setCloseAnimationDuration:.3];
    
    self.sm_CameraMode.itemsSpacing = 20.0f;
    
    [self.sm_CameraMode addItems:items];
    
    [self.cameraOverlay addSubview:self.sm_CameraMode];
    
    [self updateCameraModeIcon];
    
    for (UPStackMenuItem* item in self.sm_CameraMode.items)
    {
        [item setHidden:YES];
    }
}

- (void)installBurstMenus
{
    if (self.sm_CameraBurst)
    {
        [self.sm_CameraBurst removeFromSuperview];
    }
    
    self.sm_CameraBurst = [[UPStackMenu alloc] initWithContentView:burstContainer];
    
    CGPoint centerPoint = self.btn_Burst.center;
    
    [self.sm_CameraBurst setCenter:centerPoint];
    
    [self.sm_CameraBurst setDelegate:self];
    
    UPStackMenuItem *firstMode = Nil;
    UPStackMenuItem *secondMode = Nil;
    
    if (self.fBurstMode == FAE_CAMERA_BURST3)
    {
        firstMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_5"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        firstMode.tag = tCamera_Burst_5;
        
        secondMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_7"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        secondMode.tag = tCamera_Burst_7;
    }
    else if (self.fBurstMode == FAE_CAMERA_BURST5)
    {
        firstMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_3"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        firstMode.tag = tCamera_Burst_3;
        
        secondMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_7"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        secondMode.tag = tCamera_Burst_7;
    }
    else if (self.fBurstMode == FAE_CAMERA_BURST7)
    {
        firstMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_3"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        firstMode.tag = tCamera_Burst_3;
        
        secondMode =
        [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera_burst_5"]
                                      fillSize:burstContainer.frame.size
                              highlightedImage:nil
                                         title:@""];
        secondMode.tag = tCamera_Burst_5;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:firstMode, secondMode, nil];
    
    [self.sm_CameraBurst setAnimationType:UPStackMenuAnimationType_progressive];
    [self.sm_CameraBurst setStackPosition:UPStackMenuStackPosition_up];
    [self.sm_CameraBurst setOpenAnimationDuration:.4];
    [self.sm_CameraBurst setCloseAnimationDuration:.4];
    
    [self.sm_CameraBurst addItems:items];
    
    [self.cameraOverlay addSubview:self.sm_CameraBurst];
    
    [self updateBurstModeIcon];
    
    for (UPStackMenuItem* item in self.sm_CameraBurst.items)
    {
        [item setHidden:YES];
    }
}

- (void)updateFlashIcon
{
    // Will set new image for selected Flash Mode
    
    switch (self.fFlashMode) {
        case FAE_FLASH_AUTO:
            
            [self.btn_Flash setImage:[UIImage imageNamed:@"camera_flash_auto"] forState:UIControlStateNormal];
            
            break;
            
        case FAE_FLASH_ON:
            
            [self.btn_Flash setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
            
            break;
            
        case FAE_FLASH_OFF:
            
            [self.btn_Flash setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
            
            break;
    }
    
    [self onFlash:Nil];
    
}

- (void)updateCameraModeIcon
{
    // Will set new image for selected Camera Mode
    
    switch (self.fCameraMode) {
        case FAE_CAMERA_VIDEO:
            
            [self.btn_SwitchMode setImage:[UIImage imageNamed:@"camera_mode_v"] forState:UIControlStateNormal];
            
            break;
            
        case FAE_CAMERA_PHOTO:
            
            [self.btn_SwitchMode setImage:[UIImage imageNamed:@"camera_mode_p"] forState:UIControlStateNormal];
            
            break;
            
            default:
            
            break;
            
    }
    
    [self onSwithMode:Nil];
}

- (void)updateBurstModeIcon
{
    switch (self.fBurstMode) {
        case FAE_CAMERA_BURST3:
        {
            [self.btn_Burst setImage:[UIImage imageNamed:@"camera_burst_3"] forState:UIControlStateNormal];
        }
            break;
            
        case FAE_CAMERA_BURST5:
        {
            [self.btn_Burst setImage:[UIImage imageNamed:@"camera_burst_5"] forState:UIControlStateNormal];
        }
            break;
            
        case FAE_CAMERA_BURST7:
        {
            [self.btn_Burst setImage:[UIImage imageNamed:@"camera_burst_7"] forState:UIControlStateNormal];
        }
            break;
    }
    
    [self onBurstInterval:Nil];
}

- (CGRect) tapCheckFrame:(UIView* )srcView
{
    CGRect checkFrame = CGRectZero;
 
    if ([srcView isEqual:self.btn_SwitchMode])
    {
        checkFrame = CGRectMake(srcView.frame.origin.x - srcView.frame.size.width, srcView.frame.origin.y - srcView.frame.size.height*2, srcView.frame.size.width*3, srcView.frame.size.height * 3);
    }
    else
    {
        checkFrame = CGRectMake(srcView.frame.origin.x - srcView.frame.size.width / 2, srcView.frame.origin.y - srcView.frame.size.height/2, srcView.frame.size.width + srcView.frame.size.width, srcView.frame.size.height + srcView.frame.size.height);
    }
    
    return checkFrame;
}

- (void)previewTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(!self.tapFocusGesture) {
        return;
    }
    
    CGPoint touchedPoint = (CGPoint) [gestureRecognizer locationInView:self.view];
    
    // if touch point is in near of some buttons, then return
    
    if (CGRectContainsPoint([self tapCheckFrame:self.btn_Flash], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Flip], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Flip_Action], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_SwitchMode], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Burst], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Capture], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Back], touchedPoint)
        || CGRectContainsPoint([self tapCheckFrame:self.btn_Back_Action], touchedPoint))
    {
        return;
    }
    
    if (self.introImage.alpha == 1.0)
    {
        return;
    }
    
    // focus
    
    [self.camera setFocusOnSelectedPoint:touchedPoint];
}

#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    for (UPStackMenuItem* item in menu.items)
    {
        [item setHidden:NO];
    }
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    CGFloat timeDelayToHide = 0.0f;
    
    if ([menu isEqual:self.sm_Flash])
    {
        timeDelayToHide = 0.15;
    }
    else if ([menu isEqual:self.sm_CameraMode])
    {
        timeDelayToHide = 0.25;
    }
    else if ([menu isEqual:self.sm_CameraBurst])
    {
        timeDelayToHide = 0.15;
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeDelayToHide * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (UPStackMenuItem* item in menu.items)
        {
            [item setHidden:YES];
        }
        
    });
}

- (void)stackMenuDidOpen:(UPStackMenu *)menu
{
    NSLog(@"Did Open");
}

- (void)stackMenuDidClose:(UPStackMenu *)menu
{
    NSLog(@"Did Close");
    
    if ([menu isEqual:self.sm_Flash])
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self installFlashMenus];
            
        });
    }
    else if ([menu isEqual:self.sm_CameraMode])
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self installCameraMenus];
            
        });
    }
    else if ([menu isEqual:self.sm_CameraBurst])
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self installBurstMenus];
            
        });
    }
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    if ([menu isEqual:self.sm_Flash])
    {
        DLog(@"Flash Mode : %d : %d", index, item.tag);
        
        switch (item.tag) {
            case tCamera_Flash_Auto:
                self.fFlashMode = FAE_FLASH_AUTO;
                break;
            case tCamera_Flash_ON:
                self.fFlashMode = FAE_FLASH_ON;
                break;
            case tCamera_Flash_OFF:
                self.fFlashMode = FAE_FLASH_OFF;
                break;
        }
    }
    else if ([menu isEqual:self.sm_CameraMode])
    {
        DLog(@"Camera Mode : %d : %d", index, item.tag);
        
        if (item.tag == tCamera_Camera_Video)
        {
            self.fCameraMode = FAE_CAMERA_VIDEO;
        }
        else if (item.tag == tCamera_Camera_Photo)
        {
            self.fCameraMode = FAE_CAMERA_PHOTO;
        }
    }
    else if ([menu isEqual:self.sm_CameraBurst])
    {
        DLog(@"Burst Mode : %d : %d", index, item.tag);
        
        if (item.tag == tCamera_Burst_3)
        {
            self.fBurstMode = FAE_CAMERA_BURST3;
        }
        else if (item.tag == tCamera_Burst_5)
        {
            self.fBurstMode = FAE_CAMERA_BURST5;
        }
        else if (item.tag == tCamera_Burst_7)
        {
            self.fBurstMode = FAE_CAMERA_BURST7;
        }
    }
    
    [menu toggleStack:Nil];
}

@end

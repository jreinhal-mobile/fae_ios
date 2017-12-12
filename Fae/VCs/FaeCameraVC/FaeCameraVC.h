//
//  FaeCameraVC.h
//  Fae
//
//  Created by Jesse on 3/17/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import "UPStackMenu.h"
#import "JWGCircleCounter.h"

@interface FaeCameraVC : UIViewController<UPStackMenuDelegate, JWGCircleCounterDelegate>
{   
    IBOutlet NSLayoutConstraint*    btnFlash_LeftPadding;
    IBOutlet NSLayoutConstraint*    btnFlash_TopPadding;
    IBOutlet NSLayoutConstraint*    btnFlash_Width;
    
    IBOutlet NSLayoutConstraint*    btnFlip_RightPadding;
    IBOutlet NSLayoutConstraint*    btnFlip_TopPadding;
    IBOutlet NSLayoutConstraint*    btnFlip_Width;
    
    IBOutlet NSLayoutConstraint*    btnCapture_BottomPadding;
    IBOutlet NSLayoutConstraint*    btnCapture_Width;
    
    IBOutlet NSLayoutConstraint*    btnMode_RightPadding;
    IBOutlet NSLayoutConstraint*    btnMode_BottomPadding;
    IBOutlet NSLayoutConstraint*    btnMode_Width;
    
    IBOutlet NSLayoutConstraint*    btnBurst_RightPadding;
    IBOutlet NSLayoutConstraint*    btnBurst_BottomPadding;
    IBOutlet NSLayoutConstraint*    btnBurst_Width;
    
    IBOutlet NSLayoutConstraint*    btnBack_LeftPadding;
    IBOutlet NSLayoutConstraint*    btnBack_BottomPadding;
    IBOutlet NSLayoutConstraint*    btnBack_Width;
    
    IBOutlet NSLayoutConstraint*    btnGotit_TopPadding;
    IBOutlet NSLayoutConstraint*    btnGotit_Width;
    IBOutlet NSLayoutConstraint*    btnGotit_Height;
    
    NSString* suffixStr;
    
    BOOL isLoaded;
    
    UIView*                         flashContainer;
    UIView*                         cameraModeContainer;
    UIView*                         burstContainer;

    UIView*                         videoCircleView;
    JWGCircleCounter*               redOutlineView;
    
    CGFloat                         redCircleDiameter;
    CGFloat                         redBarThicknees;
    
    NSTimer*                        recordTimer;
    NSInteger                       remainingTime;
    
    NSTimer*                        burstTimer;
    NSInteger                       remainingBurstCount;
    
    UILongPressGestureRecognizer*   pressLongGesture;
}

// Camera Functions

- (IBAction)onBack:(id)sender;
- (IBAction)onFlash:(id)sender;
- (IBAction)onFlip:(id)sender;
- (IBAction)onCapture:(id)sender;
- (IBAction)onSwithMode:(id)sender;
- (IBAction)onBurstInterval:(id)sender;
- (IBAction)onGotit:(id)sender;

- (void)showIntro1;
- (void)showIntro2;
- (void)closeIntro;

@end

//
//  FaeProblemVC.h
//  Fae
//
//  Created by Jesse on 3/1/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaeProblemConfirmVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet    UIView*     panelScrollView;
    
    IBOutlet    UILabel*    panelNotifyLbl;
    IBOutlet    UIView*     confirmCodeView;
    
    NSMutableArray*         codeLblArray;
    
    IBOutlet    UITextField*    txt_ConfirmCode;
    
    IBOutlet    NSLayoutConstraint*     panelNotifyLbl_Height;
    IBOutlet    NSLayoutConstraint*     confirmCodeView_Height;
    IBOutlet    NSLayoutConstraint*     viewKeyboard_Height;
    IBOutlet    NSLayoutConstraint*     button_LeftPadding;
    IBOutlet    NSLayoutConstraint*     button_BottomPadding;
    IBOutlet    NSLayoutConstraint*     button_Height;
    
    IBOutlet    UIButton*   btn_ResendCode;
    IBOutlet    UIButton*   btn_Proceed;
    
    NSTimer*    resendTimer;
    NSInteger   resendCounter;
    
    CGFloat     codeFontSize;
    CGFloat     dotFontOffset;
    BOOL        codeScaledFlag;
    BOOL        isScaling;
    CGFloat     scaleFactor;
}

- (void)initUI;

- (IBAction)onBack:(id)sender;
- (IBAction)onResendCode:(id)sender;
- (IBAction)onProceed:(id)sender;

@end

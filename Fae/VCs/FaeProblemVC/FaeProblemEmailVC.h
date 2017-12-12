//
//  FaeProblemVC.h
//  Fae
//
//  Created by Jesse on 3/15/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaeProblemEmailVC : UIViewController<UITextViewDelegate, UITextFieldDelegate>
{
    IBOutlet    UIButton*   btn_Next;
    
    IBOutlet    UIView*     panelScrollView;
    IBOutlet    UILabel*    panelTtlLbl;
    IBOutlet    UIView*     panelView1;
    IBOutlet    UIImageView*    panel1_Image;
    
    IBOutlet NSLayoutConstraint*    panel1_LeftPadding;
    IBOutlet NSLayoutConstraint*    panel1_Image_TopPadding;
    IBOutlet NSLayoutConstraint*    panel1_Image_Height;
    IBOutlet NSLayoutConstraint*    panelTtlLbl_TopPadding;
    IBOutlet NSLayoutConstraint*    panelTtlLbl_Height;
    
    ////////
    
    IBOutlet UIView*        lineView_email;
    IBOutlet UIImageView*   icon_email;
    IBOutlet UITextField*           txt_email;
    IBOutlet UIImageView*   check_icon_email;
    IBOutlet UILabel*       lbl_email_notification;
    IBOutlet UIButton*      btn_clear_email;
    ////////
    
    IBOutlet NSLayoutConstraint*    lineView_email_BottomPadding;
    IBOutlet NSLayoutConstraint*    icon_email_Width;
    IBOutlet NSLayoutConstraint*    icon_email_Offset_Center;
    IBOutlet NSLayoutConstraint*    txt_email_bottom_padding;
    IBOutlet NSLayoutConstraint*    checkicon_Width;
    
    ////////
    
    IBOutlet NSLayoutConstraint*    btnHeight_Recover;
    IBOutlet NSLayoutConstraint*    btnRecover_BottomPadding;
    IBOutlet NSLayoutConstraint*    tosBottomPadding;
    
    IBOutlet    UITextView* txt_Terms;

    CGFloat     maxFontSize;
    CGFloat     dotFontSize;
    CGFloat     tosFontSize;
    
    NSInteger   cur_PageIdx;    
}

- (void)initUI;

- (IBAction)onBack:(id)sender;

- (IBAction)onNext:(id)sender;

@end

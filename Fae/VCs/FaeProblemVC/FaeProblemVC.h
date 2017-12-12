//
//  FaeProblemVC.h
//  Fae
//
//  Created by Jesse on 3/1/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaeProblemVC : UIViewController<UITextViewDelegate>
{   
    IBOutlet    UIButton*   btn_Recover;
    
    IBOutlet    UIView*     panelScrollView;
    
    IBOutlet    UIView*     panelView1;
    
    IBOutlet NSLayoutConstraint*    panel1_LeftPadding;
    
    IBOutlet NSLayoutConstraint*    panel1_Image_TopPadding;
    
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

- (IBAction)onRecover:(id)sender;

@end

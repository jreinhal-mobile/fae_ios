//
//  FaeProblemVC.h
//  Fae
//
//  Created by Jesse on 3/15/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "REPagedScrollView.h"

@interface FaeProblemAccountsVC : UIViewController<UITextViewDelegate>
{   
    IBOutlet    UIButton*   btn_EmailCode;
    
    IBOutlet    UIView*     panelScrollView;
    
    IBOutlet    UIView*     panelView1;
    IBOutlet    UILabel*    panelTtlLbl;
    
    IBOutlet UIView*        accountSwipePanel;
    IBOutlet UIButton*      btn_SwipeLeft;
    IBOutlet UIButton*      btn_SwipeRight;
    NSInteger               focused_Profile_Idx;
    
    IBOutlet    UILabel*    accountNameLbl;
    
    IBOutlet NSLayoutConstraint*    panel1_LeftPadding;
    
    IBOutlet NSLayoutConstraint*    panelLbl_BottomPadding;
    
    IBOutlet NSLayoutConstraint*    panelSwipe_CenterOffset;;
    
    IBOutlet NSLayoutConstraint*    btn_LeftSwipe_Padding;
    IBOutlet NSLayoutConstraint*    btn_RightSwipe_Padding;
    
    IBOutlet NSLayoutConstraint*    accountNameLbl_TopPadding;
    
    IBOutlet NSLayoutConstraint*    btnHeight_Recover;
    
    IBOutlet NSLayoutConstraint*    btnRecover_BottomPadding;
    
    IBOutlet NSLayoutConstraint*    tosBottomPadding;
    
    IBOutlet    UITextView* txt_Terms;

    CGFloat     maxFontSize;
    CGFloat     dotFontSize;
    CGFloat     tosFontSize;
    
    NSInteger   cur_PageIdx;
    
    CGFloat     arrowOpacityVal;
    BOOL        isScrolling;
    BOOL        isBouncing;
    
    NSTimer*    bounceTimer;
    
}

@property (strong, nonatomic) REPagedScrollView*    swipeScroll;

- (void)initUI;

- (IBAction)onBack:(id)sender;

- (IBAction)onEmailCode:(id)sender;

@end

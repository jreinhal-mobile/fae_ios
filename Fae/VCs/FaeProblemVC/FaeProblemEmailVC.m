//
//  FaeProblemVC.m
//  Fae
//
//  Created by Jesse on 3/15/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeProblemEmailVC.h"
#import "Constant.h"
#import "FaeAppDelegate.h"
#import "FaeProblemEmailVC.h"
#import "FaeProblemAccountsVC.h"
#import "FaeWelcomeVC.h"
#import "FaeSigninVC.h"
#import "FaeProblemVC.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>

#define Alert1  @"Enter your Email to\nfind your Account"
#define Alert2  @"Oh No! We can’t find an\nAccount with that Email..."

@interface FaeProblemEmailVC ()

@end

@implementation FaeProblemEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    // Set Alert
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if (gDeviceType == DEVICE_IPHONE_35INCH)
    {
        panel1_LeftPadding.constant = 20.0f;
        
        panelTtlLbl_TopPadding.constant = -10.0f;
        panelTtlLbl_Height.constant = 45.0f;
        
        panel1_Image_TopPadding.constant = 15.0f;
        panel1_Image_Height.constant = 75.0f;
        
        icon_email_Width.constant = 18.0f;
        icon_email_Offset_Center.constant = 0.0f;
        txt_email_bottom_padding.constant = -3.0f;
        checkicon_Width.constant = 15.0f;
        lineView_email_BottomPadding.constant = 55.0f;
        
        btnRecover_BottomPadding.constant = 0.0f;
        
        tosBottomPadding.constant = 40.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        panel1_LeftPadding.constant = 20.0f;
        
        panelTtlLbl_TopPadding.constant = 5.0f;
        panelTtlLbl_Height.constant = 45.0f;
        
        panel1_Image_TopPadding.constant = 30.0f;
        panel1_Image_Height.constant = 75.0f;
        
        icon_email_Width.constant = 18.0f;
        icon_email_Offset_Center.constant = 0.0f;
        txt_email_bottom_padding.constant = -3.0f;
        checkicon_Width.constant = 15.0f;
        lineView_email_BottomPadding.constant = 40.0f;
        
        btnRecover_BottomPadding.constant = 30.0f;
        
        tosBottomPadding.constant = 70.0f;
    }
    else
    {
        panel1_LeftPadding.constant = 30.0f;
        
        icon_email_Width.constant = 21.0f;
        icon_email_Offset_Center.constant = 2.0f;
        txt_email_bottom_padding.constant = 1.0f;
        checkicon_Width.constant = 19.0f;
        
        
        if (gDeviceType == DEVICE_IPHONE_47INCH)
        {
            panelTtlLbl_TopPadding.constant = 0.0f;
            panelTtlLbl_Height.constant = 60.0f;
            
            panel1_Image_TopPadding.constant = 25.0f;
            panel1_Image_Height.constant = 104.0f;
            
            btnRecover_BottomPadding.constant = 30.0f;
            
            lineView_email_BottomPadding.constant = 55.0f;
        }
        else
        {
            panelTtlLbl_TopPadding.constant = 10.0f;
            panelTtlLbl_Height.constant = 60.0f;
            
            panel1_Image_TopPadding.constant = 40.0f;
            panel1_Image_Height.constant = 104.0f;
            
            btnRecover_BottomPadding.constant = 30.0f;
            
            lineView_email_BottomPadding.constant = 80.0f;
        }
        
        tosBottomPadding.constant = 110.0f;
    }
    
    ////
    
    [panelTtlLbl setTextColor:RED_COLOR];
    
    [panelTtlLbl setText:Alert1];
    
    if (gDeviceType == DEVICE_IPHONE_35INCH
        || gDeviceType == DEVICE_IPHONE_40INCH)
    {
        [panelTtlLbl setFont:FONT_SEMIBOLD(16)];
        
    }
    else
    {
        [panelTtlLbl setFont:FONT_SEMIBOLD(22)];
    }
    
    [panel1_Image setImage:[UIImage imageNamed:@"problem_account_smile"]];
    
    ////
    
    btnHeight_Recover.constant = gButton_Height;
    [btn_Next.titleLabel setFont:gButtonFont];
        
    [btn_Next setBackgroundColor:RED_COLOR];
    [btn_Next.layer setCornerRadius:8.f];
    [btn_Next.titleLabel setTextColor:[UIColor whiteColor]];
    
    [btn_Next bbc_backgroundColorNormal:RED_COLOR
                backgroundColorSelected:RED_COLOR_SELECTED];
    
    [btn_Next setBackgroundColor:RED_COLOR_WITHOPACITY];
    [btn_Next setUserInteractionEnabled:NO];
    
    // Textfield
    
    [lineView_email setBackgroundColor:GRAY_COLOR];
    [icon_email setImage:[UIImage imageNamed:@"email_gray"]];
    [check_icon_email setImage:Nil];
    [txt_email setBackgroundColor:[UIColor clearColor]];
    [txt_email setFont:gInputTextFont];
    [txt_email setTextColor:RED_COLOR];
    [txt_email setTintColor:RED_COLOR];
    
    [txt_email addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    [btn_clear_email setHidden:YES];
    
    // Init Terms and Service Label
    
    if (gDeviceType == DEVICE_IPHONE_47INCH
        || gDeviceType == DEVICE_IPHONE_55INCH)
    {
        maxFontSize = 18;
        dotFontSize = 21.0f;
        tosFontSize = 15.0f;
    }
    else
    {
        maxFontSize = 17;
        dotFontSize = 21.0f;
        tosFontSize = 13.0f;
    }
    
    NSString* string1 = @"For other problems with signin in\nor the account in general, enter Fae\nas ";
    NSString* string2 = @" and contact ";
    NSString* string3 = @" directly";
    
    
    NSDictionary *thin_attributes = @{NSFontAttributeName:gTermOfServiceNormalFont,
                                      NSForegroundColorAttributeName:RED_COLOR
                                      };
    
    NSDictionary *bold_attributes = @{NSFontAttributeName:gTermOfServiceBoldFont,
                                      NSForegroundColorAttributeName:RED_COLOR
                                      };
    
    NSMutableAttributedString *attributedString1 =
    [[NSMutableAttributedString alloc] initWithString:string1
                                           attributes:thin_attributes];
    
    NSMutableAttributedString *attributedString2 =
    [[NSMutableAttributedString alloc] initWithString:string2
                                           attributes:thin_attributes];
    
    NSMutableAttributedString *attributedString3 =
    [[NSMutableAttributedString alloc] initWithString:string3
                                           attributes:thin_attributes];
    
    NSMutableAttributedString *attributedGuest =
    [[NSMutableAttributedString alloc] initWithString:PROBLEM_GUEST
                                           attributes:bold_attributes];
    
    NSMutableAttributedString *attributedSupport =
    [[NSMutableAttributedString alloc] initWithString:PROBLEM_SUPPORT
                                           attributes:bold_attributes];
    
    [attributedGuest addAttribute:NSLinkAttributeName
                              value:PROBLEM_GUEST_link
                              range:NSMakeRange(0, PROBLEM_GUEST.length)];
    
    [attributedSupport addAttribute:NSLinkAttributeName
                            value:PROBLEM_SUPPORT_link
                            range:NSMakeRange(0, PROBLEM_SUPPORT.length)];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    [attributedString1 appendAttributedString:attributedGuest];
    [attributedString1 appendAttributedString:attributedString2];
    [attributedString1 appendAttributedString:attributedSupport];
    [attributedString1 appendAttributedString:attributedString3];
    
    [txt_Terms setScrollEnabled:NO];
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString1.string.length)];
    [txt_Terms setAttributedText:attributedString1];
    
    txt_Terms.linkTextAttributes = @{NSForegroundColorAttributeName : RED_COLOR};
    
    [txt_Terms setBackgroundColor:[UIColor clearColor]];
    
    txt_Terms.selectable = YES;
    txt_Terms.dataDetectorTypes = UIDataDetectorTypeAll;
    [txt_Terms setEditable:NO];
    txt_Terms.delegate = self;
    
#ifdef WORKMODE
    
    txt_email.text = @"g@gmail.com";
    
#endif   
    
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

// - Update UI Control's color and status
- (void)updateUIStatus:(UITextField* )textField DynamicalCheck:(BOOL)isDynamic
{
    // Check Email field
    if ([textField isEqual:txt_email])
    {
        [txt_email setFont:FONT_LIGHT(maxFontSize)];
        [lbl_email_notification setText:@""];
        
        if (textField.text.length == 0
            || textField.text == Nil
            || [textField.text isEqualToString:@""])
        {
            // No process
            
            [icon_email setImage:[UIImage imageNamed:EMAIL_RED]];
            [lineView_email setBackgroundColor:RED_COLOR];
            
            [check_icon_email setImage:Nil];
            [btn_clear_email setHidden:YES];
            [lbl_email_notification setText:@""];
            
            [btn_Next setBackgroundColor:RED_COLOR_WITHOPACITY];
            [btn_Next setUserInteractionEnabled:NO];
        }
        else
        {
            [icon_email setImage:[UIImage imageNamed:EMAIL_RED]];
            [lineView_email setBackgroundColor:RED_COLOR];
            
            if ([[FaeAppDelegate sharedDelegate] isValidEmail:textField.text])
            {
                [check_icon_email setImage:[UIImage imageNamed:CHECK_YES]];
                [btn_clear_email setHidden:YES];
                
                [btn_Next setBackgroundColor:RED_COLOR];
                [btn_Next setUserInteractionEnabled:YES];
                
            }
            else
            {
                [check_icon_email setImage:[UIImage imageNamed:CHECK_CROSS_RED]];
                [btn_clear_email setHidden:NO];
                
                [btn_Next setBackgroundColor:RED_COLOR_WITHOPACITY];
                [btn_Next setUserInteractionEnabled:NO];
            }
        }
    }   // Check Phone field
    
}

#pragma mark - IBActions

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender
{
    DLog(@"Go to Next View");
    
    FaeProblemAccountsVC* accountVC = [[FaeProblemAccountsVC alloc] initWithNibName:@"FaeProblemAccountsVC" bundle:Nil];
    
    [self.navigationController pushViewController:accountVC animated:YES];    
}

- (IBAction)onClear:(id)sender
{
    [check_icon_email setImage:Nil];
    [btn_clear_email setHidden:YES];
    
    txt_email.text = @"";
    
    [self updateUIStatus:txt_email DynamicalCheck:NO];
}

#pragma mark - UITextField Delegates

// Check the textfield whenever change event is occured

-(void)textFieldDidChange :(UITextField *)textField
{
    [self updateUIStatus:textField DynamicalCheck:YES];
}

// If the textField get the focus, then update the UI controls

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:RED_COLOR];
    [textField setTintColor:RED_COLOR];
    
    [txt_email layoutIfNeeded];
    
    [self updateUIStatus:textField DynamicalCheck:YES];
    
    [icon_email setImage:[UIImage imageNamed:EMAIL_RED]];
    [lineView_email setBackgroundColor:RED_COLOR];
}

// If the textField drop the focus, then update the UI controls

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [txt_email layoutIfNeeded];
    
    if ([textField isEqual:txt_email])
    {
        [self updateUIStatus:textField DynamicalCheck:NO];
        
        if (textField.text.length == 0
            || textField.text == Nil
            || [textField.text isEqualToString:@""])
        {
            [icon_email setImage:[UIImage imageNamed:EMAIL_GRAY]];
            [lineView_email setBackgroundColor:GRAY_COLOR];
        }
        else
        {
            [icon_email setImage:[UIImage imageNamed:EMAIL_RED]];
            [lineView_email setBackgroundColor:RED_COLOR];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

// Keyboard update accoording to the Return button

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        if ([textField isEqual:txt_email])
        {
            [textField resignFirstResponder];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - CCHLinkAttributeName Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString* openPath = [URL absoluteString];
    
    DLog(@"%@", openPath);
    
    if ([openPath isEqualToString:PROBLEM_GUEST_link]
        || [openPath isEqualToString:PROBLEM_SUPPORT_link])
    {
        NSInteger pushedVC_count = [self.navigationController.viewControllers count];
        
        if (pushedVC_count)
        {
            UIViewController* checkVC = Nil;
            
            NSMutableArray*    vcArrays = [[NSMutableArray alloc] init];
            
            vcArrays = [self.navigationController.viewControllers mutableCopy];
            
            DLog(@"%@", vcArrays);
            
            for (NSInteger i = 0 ; i < [vcArrays count] ; i ++)
            {
                checkVC = [vcArrays objectAtIndex:i];
                
                if ([checkVC isKindOfClass:[FaeSigninVC class]])
                {
                    [vcArrays removeObject:checkVC];
                    
                    DLog(@"%@", vcArrays);
                    
                    break;
                }
            }
            
            for (NSInteger i = 0 ; i < [vcArrays count] ; i ++)
            {
                checkVC = [vcArrays objectAtIndex:i];
                
                if ([checkVC isKindOfClass:[FaeProblemVC class]])
                {
                    [vcArrays removeObject:checkVC];
                    
                    DLog(@"%@", vcArrays);
                    
                    break;
                }
            }
            
            [self.navigationController setViewControllers:vcArrays];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:URL])
    {
        [[UIApplication sharedApplication] openURL:URL];
    }
    
    return NO;
}

@end

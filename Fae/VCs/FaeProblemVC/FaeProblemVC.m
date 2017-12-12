//
//  FaeProblemVC.m
//  Fae
//
//  Created by Jesse on 3/1/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeProblemVC.h"
#import "Constant.h"
#import "FaeAppDelegate.h"
#import "FaeWelcomeVC.h"
#import "FaeSigninVC.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "FaeProblemEmailVC.h"

@interface FaeProblemVC ()

@end

@implementation FaeProblemVC

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
    
    if (gDeviceType == DEVICE_IPHONE_35INCH)
    {
        panel1_LeftPadding.constant = 20.0f;
        
        panel1_Image_TopPadding.constant = 0.0f;
        
        btnRecover_BottomPadding.constant = 0.0f;
        
        tosBottomPadding.constant = 40.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        panel1_LeftPadding.constant = 20.0f;
        
        panel1_Image_TopPadding.constant = 15.0f;
        
        btnRecover_BottomPadding.constant = 30.0f;
        
        tosBottomPadding.constant = 70.0f;
    }
    else
    {
        panel1_LeftPadding.constant = 30.0f;
        
        panel1_Image_TopPadding.constant = 20.0f;
        
        btnRecover_BottomPadding.constant = 30.0f;
        
        tosBottomPadding.constant = 110.0f;
    }
    
    btnHeight_Recover.constant = gButton_Height;
    
    [btn_Recover.titleLabel setFont:gButtonFont];
    
    [btn_Recover bbc_backgroundColorNormal:RED_COLOR
                  backgroundColorSelected:RED_COLOR_SELECTED];
        
    [btn_Recover setBackgroundColor:RED_COLOR];
    [btn_Recover.layer setCornerRadius:8.f];
    [btn_Recover.titleLabel setTextColor:[UIColor whiteColor]];
    
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
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRecover:(id)sender
{
    // Will go to email VC
    
    FaeProblemEmailVC* emailVC = [[FaeProblemEmailVC alloc] initWithNibName:@"FaeProblemEmailVC" bundle:Nil];
    
    [self.navigationController pushViewController:emailVC animated:YES];
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

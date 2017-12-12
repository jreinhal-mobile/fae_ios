//
//  FaeProblemVC.m
//  Fae
//
//  Created by Jesse on 3/1/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeProblemAccountsVC.h"
#import "Constant.h"
#import "FaeAppDelegate.h"
#import "FaeWelcomeVC.h"
#import "FaeSigninVC.h"
#import "FaeProblemVC.h"
#import "FaeProblemEmailVC.h"
#import "FaeProblemConfirmVC.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "REPagedScrollView.h"
#import "UIView+DCAnimationKit.h"

@interface FaeProblemAccountsVC ()

@end

@implementation FaeProblemAccountsVC

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
        
        panelLbl_BottomPadding.constant = 20.0f;
        
        panelSwipe_CenterOffset.constant = -40.0f;
        
        accountNameLbl_TopPadding.constant = -10.0f;
        
        btnRecover_BottomPadding.constant = 0.0f;
        
        tosBottomPadding.constant = 20.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        panel1_LeftPadding.constant = 20.0f;
        
        panelLbl_BottomPadding.constant = 50.0f;
        
        panelSwipe_CenterOffset.constant = -20.0f;
        
        accountNameLbl_TopPadding.constant = -5.0f;
        
        btnRecover_BottomPadding.constant = 30.0f;
        
        tosBottomPadding.constant = 50.0f;
    }
    else
    {
        panel1_LeftPadding.constant = 30.0f;
        
        panelLbl_BottomPadding.constant = 50.0f;
        
        panelSwipe_CenterOffset.constant = -20.0f;
        
        accountNameLbl_TopPadding.constant = 5.0f;
        
        btnRecover_BottomPadding.constant = 30.0f;
        
        tosBottomPadding.constant = 90.0f;
    }
    
    [panelTtlLbl setTextColor:RED_COLOR];
    
    if ([[FaeAppDelegate sharedDelegate] countOfProblemAccounts] == 1)
    {
        [panelTtlLbl setText:@"Found Account"];
    }
    else
    {
        [panelTtlLbl setText:@"Found Accounts"];
    }
    
    [accountNameLbl setTextColor:RED_COLOR];
    [accountNameLbl setFont:gInputTextFont];
    
    if (gDeviceType == DEVICE_IPHONE_35INCH
        || gDeviceType == DEVICE_IPHONE_40INCH)
    {
        [panelTtlLbl setFont:FONT_SEMIBOLD(18)];
        
    }
    else
    {
        [panelTtlLbl setFont:FONT_SEMIBOLD(25)];
    }
    
    btnHeight_Recover.constant = gButton_Height;
    
    [btn_EmailCode.titleLabel setFont:gButtonFont];
    
    [btn_EmailCode bbc_backgroundColorNormal:RED_COLOR
                  backgroundColorSelected:RED_COLOR_SELECTED];
        
    [btn_EmailCode setBackgroundColor:RED_COLOR];
    [btn_EmailCode.layer setCornerRadius:8.f];
    [btn_EmailCode.titleLabel setTextColor:[UIColor whiteColor]];
    
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
    
    /*
     Guest andcontact
     Support directly.
     */
    NSString* string1 = @"Not  your Account?\nTry Entering your email again or\nenter Fae as ";
    NSString* string2 = @" and contact\n";
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
    
    if ([[FaeAppDelegate sharedDelegate] countOfProblemAccounts] > 0)
    {
        [accountSwipePanel setHidden:NO];
        
        [self initAccouts];
    }
}

- (void)initAccouts
{
    [accountSwipePanel setBackgroundColor:[UIColor clearColor]];
    
    DLog(@"%@", NSStringFromCGRect(accountSwipePanel.frame));
    
    _swipeScroll = [[REPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, gScreenSize.width, accountSwipePanel.frame.size.height)];
    
    [_swipeScroll setBackgroundColor:[UIColor clearColor]];
    [_swipeScroll.pageControl setHidden:YES];
    _swipeScroll.delegate = self;
    
    [accountSwipePanel addSubview:_swipeScroll];
    [accountSwipePanel sendSubviewToBack:_swipeScroll];
    [accountSwipePanel bringSubviewToFront:btn_SwipeLeft];
    [accountSwipePanel bringSubviewToFront:btn_SwipeRight];
    
    // Set Button's Frame
    
    CGFloat swipeBtnPadding = 0.0f;
    
    swipeBtnPadding = (((gScreenSize.width - accountSwipePanel.frame.size.height) / 2 ) - btn_SwipeLeft.frame.size.width) / 2;
    
    btn_LeftSwipe_Padding.constant = swipeBtnPadding;
    btn_RightSwipe_Padding.constant = swipeBtnPadding;
    
    CGFloat imageWidth = 0.0f;
    
    if (gDeviceType == DEVICE_IPHONE_35INCH
        || gDeviceType == DEVICE_IPHONE_40INCH)
    {
        imageWidth = 90.0f;
    }
    else
    {
        imageWidth = 125.0f;
    }
    
    if (accountSwipePanel.frame.size.height < imageWidth)
    {
        imageWidth = accountSwipePanel.frame.size.height;
    }
    
    for (int i = 0 ; i < [[FaeAppDelegate sharedDelegate] countOfProblemAccounts] ; i ++)
    {
        UIView* view_ProfileAccount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gScreenSize.width, accountSwipePanel.frame.size.height)];
        
        view_ProfileAccount.backgroundColor = [UIColor clearColor];
        
        UIImageView* profileImg = [[UIImageView alloc] initWithFrame:CGRectMake((gScreenSize.width - imageWidth) / 2, (accountSwipePanel.frame.size.height - imageWidth) / 2, imageWidth, imageWidth)];
        
        profileImg.tag = 2000 + i;
        
        [view_ProfileAccount addSubview:profileImg];
        
        if ((i%2) == 0)
        {
            [profileImg setImage:[UIImage imageNamed:@"account_1"]];
        }
        else if ((i%2) == 1)
        {
            [profileImg setImage:[UIImage imageNamed:@"account_2"]];
        }
        
        [_swipeScroll addPage:view_ProfileAccount];
    }
    
    if (_swipeScroll.pages.count)
    {
        [_swipeScroll scrollToPageWithIndex:0 animated:NO];
        
        focused_Profile_Idx = 0;
    }
    else
    {
        [accountSwipePanel setHidden:YES];
        
        focused_Profile_Idx = -1;
    }
    
    arrowOpacityVal = 1.0f;
    
    [self updateSwipeButtons];
    
    [self updateArrowAnimation];
    
}

- (void)updateSwipeButtons
{
    if (isScrolling)
    {
        btn_SwipeLeft.alpha = 0.0f;
        btn_SwipeRight.alpha = 0.0f;
    }
    else
    {
        if (_swipeScroll.pages.count > 1)
        {
            if (focused_Profile_Idx == 0)
            {
                btn_SwipeLeft.alpha = 0.0f;
                
                btn_SwipeRight.alpha = 0.0f;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     btn_SwipeRight.alpha = 1.0;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
            }
            else if (focused_Profile_Idx < (_swipeScroll.pages.count - 1))
            {
                btn_SwipeLeft.alpha = 0.0f;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     btn_SwipeLeft.alpha = 1.0;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
                btn_SwipeRight.alpha = 0.0f;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     btn_SwipeRight.alpha = 1.0;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
            }
            else
            {
                btn_SwipeLeft.alpha = 0.0f;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     btn_SwipeLeft.alpha = 1.0;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
                
                btn_SwipeRight.alpha = 0.0;
            }
            
        }
        else
        {
            [btn_SwipeLeft setAlpha:0.0f];
            [btn_SwipeRight setAlpha:0.0f];
        }
    }
    
    accountNameLbl.text = [NSString stringWithFormat:@"Beta Tester %d", (int)focused_Profile_Idx];
}

- (void)updateArrowAnimation
{
    DLog(@"Stopped Scrolling");
    
    [self bounceEffect];
    
    bounceTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                   target:self
                                                 selector:@selector(bounceEffect)
                                                 userInfo:Nil
                                                  repeats:YES];
    
    
}

- (void)bounceEffect
{
    {
        [btn_SwipeLeft bounce_Left:8.0f finished:^{
            
            DLog(@"Bounced - Left");
            
        }];
    }
    
    {
        [btn_SwipeRight bounce_Right:8.0f finished:^{
            
            DLog(@"Bounced - Right");
            
        }];
    }
}

#pragma mark - IBActions

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEmailCode:(id)sender
{
    // Will go to email VC
    
    FaeProblemConfirmVC* confirmVC = [[FaeProblemConfirmVC alloc] initWithNibName:@"FaeProblemConfirmVC" bundle:Nil];
    
    [self.navigationController pushViewController:confirmVC animated:YES];
}

- (IBAction)onSwipeLeft:(id)sender
{
    if (focused_Profile_Idx == 0)
    {
        
    }
    else if (focused_Profile_Idx < _swipeScroll.pages.count)
    {
        [_swipeScroll scrollToPageWithIndex:(focused_Profile_Idx - 1) animated:YES];
    }
    
    [self updateSwipeButtons];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        [self updateArrowAnimation];
        
    });
}

- (IBAction)onSwipeRight:(id)sender
{
    if (focused_Profile_Idx < _swipeScroll.pages.count)
    {
        [_swipeScroll scrollToPageWithIndex:(focused_Profile_Idx + 1) animated:YES];
    }
    
    [self updateSwipeButtons];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self updateArrowAnimation];
        
    });
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
            
            for (NSInteger i = 0 ; i < [vcArrays count] ; i ++)
            {
                checkVC = [vcArrays objectAtIndex:i];
                
                if ([checkVC isKindOfClass:[FaeProblemEmailVC class]])
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

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)src_scrollView
{
    if ([src_scrollView isEqual:_swipeScroll.scrollView])
    {
        if (bounceTimer)
        {
            [bounceTimer invalidate];
            bounceTimer = Nil;
        }
        
        CGFloat pageWidth = src_scrollView.frame.size.width;
        
        CGFloat offsetVal = (src_scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth;
        
        int page = floor(offsetVal) + 1;
        
        focused_Profile_Idx = page;
        
        CGFloat opacityVal = ABS((NSInteger)(offsetVal*100) - 50);
        
        if (((int)opacityVal % 100) == 0)
        {
            isScrolling = NO;
        }
        else
        {
            isScrolling = YES;
        }
        
        [self updateSwipeButtons];
    }
    else
    {
        src_scrollView.contentOffset = CGPointMake(src_scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScrolling = NO;
    
    [self updateSwipeButtons];
    
    [self updateArrowAnimation];
}

@end

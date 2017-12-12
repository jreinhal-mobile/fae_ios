//
//  FaeProblemVC.m
//  Fae
//
//  Created by Jesse on 3/15/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeProblemConfirmVC.h"
#import "Constant.h"
#import "FaeAppDelegate.h"
#import "FaeWelcomeVC.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "FaeProblemEmailVC.h"
#import "FaeProblemPasswordVC.h"

#define Alert1  @"Enter the Code we just sent to your\nemail to continue..."
#define Alert2  @"That’s an incorrect Code!\nPlease try again!"
#define MAX_CODELENGTH  6

@interface FaeProblemConfirmVC ()

@end

@implementation FaeProblemConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        button_LeftPadding.constant = 20.0f;
        button_BottomPadding.constant = 20.0f;
        
        panelNotifyLbl_Height.constant = 40.0f;
        confirmCodeView_Height.constant = 50.0f;
        viewKeyboard_Height.constant = 200.0f;
        codeFontSize = 43.0f;
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        button_LeftPadding.constant = 20.0f;
        button_BottomPadding.constant = 30.0f;
        
        panelNotifyLbl_Height.constant = 40.0f;
        confirmCodeView_Height.constant = 50.0f;
        viewKeyboard_Height.constant = 200.0f;
        codeFontSize = 43.0f;
    }
    else
    {
        button_LeftPadding.constant = 30.0f;
        button_BottomPadding.constant = 40.0f;
        
        panelNotifyLbl_Height.constant = 60.0f;
        confirmCodeView_Height.constant = 100.0f;
        viewKeyboard_Height.constant = 210.0f;
        codeFontSize = 59.0f;
    }
    
    dotFontOffset = 15.0f;
    
    button_Height.constant = gButton_Height;
    
    [btn_Proceed.titleLabel setFont:gButtonFont];
    [btn_ResendCode.titleLabel setFont:gButtonFont];
    [btn_Proceed.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn_ResendCode.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [btn_Proceed setTitle:@"Proceed" forState:UIControlStateNormal];
    
    [btn_ResendCode setTitle:@"Resend Code 60" forState:UIControlStateNormal];
    
    [btn_Proceed.layer setCornerRadius:8.0f];
    [btn_Proceed.titleLabel setTextColor:[UIColor whiteColor]];
    [btn_Proceed bbc_backgroundColorNormal:RED_COLOR_WITHOPACITY
                   backgroundColorSelected:RED_COLOR_WITHOPACITY];
    
    
    [btn_ResendCode.layer setCornerRadius:8.0f];
    [btn_ResendCode.titleLabel setTextColor:[UIColor whiteColor]];
    [btn_ResendCode bbc_backgroundColorNormal:RED_COLOR_WITHOPACITY
                      backgroundColorSelected:RED_COLOR_WITHOPACITY];
    
    [btn_Proceed setBackgroundColor:RED_COLOR_WITHOPACITY];
    [btn_ResendCode setBackgroundColor:RED_COLOR_WITHOPACITY];
    
    [btn_Proceed setUserInteractionEnabled:NO];
    [btn_ResendCode setUserInteractionEnabled:NO];
    
    [panelNotifyLbl setTextColor:GRAY_COLOR];
    [panelNotifyLbl setText:Alert1];
    
    if (gDeviceType == DEVICE_IPHONE_35INCH
        || gDeviceType == DEVICE_IPHONE_40INCH)
    {
        [panelNotifyLbl setFont:FONT_REGULAR(13)];
    }
    else
    {
        [panelNotifyLbl setFont:FONT_REGULAR(18)];
    }
    
    [txt_ConfirmCode becomeFirstResponder];
    txt_ConfirmCode.autocorrectionType = UITextAutocorrectionTypeNo;
    [txt_ConfirmCode addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    
    [self initCodeLabels];
    
    double delayInSeconds = 0.1f;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self startTimer];
        
    });
    
    
}

- (void)initCodeLabels
{
    CGFloat labelWidth = 40.0f;
    
    if (gDeviceType == DEVICE_IPHONE_35INCH
        || gDeviceType == DEVICE_IPHONE_40INCH)
    {
        labelWidth = 30.0f;
    }
    else
    {
        labelWidth = 40.0f;
    }
    
    CGFloat labelHeight = confirmCodeView_Height.constant;
    
    codeLblArray = [[NSMutableArray alloc] init];
    
    CGFloat curXpos = 0.0f;
    
    curXpos = (gScreenSize.width - (labelWidth * MAX_CODELENGTH)) / 2;
    
    for (NSInteger i = 0 ; i < MAX_CODELENGTH ; i ++)
    {
        UILabel* codeLbl = [[UILabel alloc] initWithFrame:CGRectMake(curXpos + (i*labelWidth), 0, labelWidth, labelHeight)];
        
        [codeLbl setTag:(5000 + i)];
        [codeLbl setTextColor:RED_COLOR];
        [codeLbl setBackgroundColor:[UIColor clearColor]];
        
//        [codeLbl setFont:FONT_REGULAR(codeFontSize)];
        
        [codeLbl setFont:FONT_DOT(codeFontSize-dotFontOffset)];
        
        [codeLbl setText:STRING_DOT];
        
        [codeLbl setTextAlignment:NSTextAlignmentCenter];
        
        [confirmCodeView addSubview:codeLbl];
        
        [codeLblArray addObject:codeLbl];
    }
    
    codeScaledFlag = NO;
    isScaling = NO;
}

- (BOOL)checkCode
{
    BOOL retVal = NO;
    
    NSString* default_ConfirmCode = @"689689";
    
    if ([txt_ConfirmCode.text isEqualToString:default_ConfirmCode])
    {
        retVal = YES;
    }
    
    return retVal;
}

- (void)startTimer
{
    [btn_ResendCode setUserInteractionEnabled:NO];
    
    resendCounter = 60;
    
    resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(updateButtonTitle)
                                                 userInfo:Nil
                                                  repeats:YES];
}

- (void) updateButtonTitle
{
    resendCounter = resendCounter - 1;
    
    [btn_ResendCode.titleLabel setFont:gButtonFont];
    
    if (resendCounter == 0)
    {
        [btn_ResendCode setBackgroundColor:RED_COLOR];
        [btn_ResendCode setTitle:@"Resend Code" forState:UIControlStateNormal];
        [btn_ResendCode setUserInteractionEnabled:YES];
        
        [resendTimer invalidate];
        
        resendTimer = Nil;
    }
    else
    {
        [btn_ResendCode setBackgroundColor:RED_COLOR_WITHOPACITY];
        [btn_ResendCode setTitle:[NSString stringWithFormat:@"Resend Code %d", (int)resendCounter] forState:UIControlStateNormal];
        [btn_ResendCode setUserInteractionEnabled:NO];
    }
}

- (void)scaleUpCode
{
    // Enlarge confirmCodeView
    
    if (codeScaledFlag == NO)
    {
        if (isScaling)
        {
            return;
        }
        
        isScaling = YES;
        
        [btn_Proceed setUserInteractionEnabled:NO];
        [panelNotifyLbl setHidden:YES];
        
        scaleFactor = 1.3;
        
        CGPoint finalPoint = CGPointMake(gScreenSize.width / 2,(confirmCodeView_Height.constant * scaleFactor ) /2);
        
        CGAffineTransform tr = CGAffineTransformScale(confirmCodeView.transform, scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:0
                         animations:^{
                             
                             confirmCodeView.transform = tr;
                             confirmCodeView.center = finalPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             codeScaledFlag = YES;
                             
                             isScaling = NO;
                             
                             [btn_Proceed setBackgroundColor:RED_COLOR];
                             [btn_Proceed setUserInteractionEnabled:YES];
                         }];
    }
}

- (void)scaleDownCode
{
    if (codeScaledFlag)
    {
        if (isScaling)
        {
            return;
        }
        
        isScaling = YES;
        
        scaleFactor = 1 / 1.3;
        
        CGPoint finalPoint = CGPointMake(gScreenSize.width / 2, panelNotifyLbl_Height.constant +  (confirmCodeView_Height.constant * scaleFactor ) /2);
        
        CGAffineTransform tr = CGAffineTransformScale(confirmCodeView.transform, scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:0
                         animations:^{
                             
                             confirmCodeView.transform = tr;
                             confirmCodeView.center = finalPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
                             {
                                 UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
                                 
                                 [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
                                 
                                 [focusedLabel setText:STRING_DOT];
                             }
                             
                             isScaling = NO;
                             
                             codeScaledFlag = NO;
                             
                         }];
    }
}

#pragma mark - IBActions

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onResendCode:(id)sender
{
    [panelNotifyLbl setHidden:NO];
    [panelNotifyLbl setText:Alert1];
    
    [txt_ConfirmCode setText:@""];
    
    [btn_Proceed setUserInteractionEnabled:NO];
    [btn_Proceed setBackgroundColor:RED_COLOR_WITHOPACITY];
    
    [btn_ResendCode setTitle:@"Resend Code 60" forState:UIControlStateNormal];
    
    if (codeScaledFlag)
    {
        // Scale down the code view to original position
        
        if (isScaling)
        {
            return;
        }
        
        isScaling = YES;
        
        scaleFactor = 1 / 1.3;
        
        CGPoint finalPoint = CGPointMake(gScreenSize.width / 2, panelNotifyLbl_Height.constant +  (confirmCodeView_Height.constant * scaleFactor ) /2);
        
        CGAffineTransform tr = CGAffineTransformScale(confirmCodeView.transform, scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:0
                         animations:^{
                             
                             confirmCodeView.transform = tr;
                             confirmCodeView.center = finalPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
                             {
                                 UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
                                 
                                 [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
                                 
                                 [focusedLabel setText:STRING_DOT];
                             }
                             
                             isScaling = NO;
                             
                             codeScaledFlag = NO;
                             
                             [self startTimer];                             
                         }];
    }
    else
    {
        // Init all dots again
        
        for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
        {
            UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
            
            [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
            
            [focusedLabel setText:STRING_DOT];
        }
        
        [self startTimer];
    }
    
}

- (IBAction)onProceed:(id)sender
{
    if ([self checkCode])
    {
        FaeProblemPasswordVC* passwordVC = [[FaeProblemPasswordVC alloc] initWithNibName:@"FaeProblemPasswordVC" bundle:Nil];
        
        [self.navigationController pushViewController:passwordVC animated:YES];
        
        [self scaleUpCode];
        
        // Reset the Resend Button and Timer
        
        [btn_ResendCode.titleLabel setText:@"Resend Code"];
        [btn_ResendCode setBackgroundColor:RED_COLOR];
        [btn_ResendCode setUserInteractionEnabled:YES];
        
        [resendTimer invalidate];
        
        resendTimer = Nil;
        
    }
    else
    {
        [txt_ConfirmCode setText:@""];
        
        [btn_Proceed setUserInteractionEnabled:NO];
        [btn_Proceed setBackgroundColor:RED_COLOR_WITHOPACITY];
        
        if (isScaling)
        {
            return;
        }
        
        isScaling = YES;
        
        scaleFactor = 1 / 1.3;
        
        CGPoint finalPoint = CGPointMake(gScreenSize.width / 2, panelNotifyLbl_Height.constant +  (confirmCodeView_Height.constant * scaleFactor ) /2);
        
        CGAffineTransform tr = CGAffineTransformScale(confirmCodeView.transform, scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:0
                         animations:^{
                             
                             confirmCodeView.transform = tr;
                             confirmCodeView.center = finalPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             [panelNotifyLbl setHidden:NO];
                             [panelNotifyLbl setText:Alert2];
                             
                             for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
                             {
                                 UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
                                 
                                 [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
                                 
                                 [focusedLabel setText:STRING_DOT];
                             }
                             
                             isScaling = NO;
                             
                             codeScaledFlag = NO;
                         }];
    }
}

#pragma mark - UITextField Delegates

// Check the textfield whenever change event is occured

-(void)textFieldDidChange :(UITextField *)textField
{
    DLog(@"%@", textField.text);
    
    if (textField.text.length > 0)
    {
        NSInteger codeLength = textField.text.length;
        
        for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
        {
            UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
            
            if (i < codeLength)
            {
                NSString* newCode = [textField.text substringWithRange:NSMakeRange(i, 1)];
                
                [focusedLabel setFont:FONT_REGULAR(codeFontSize)];
                
                [focusedLabel setText:newCode];
            }
            else
            {
                [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
                
                [focusedLabel setText:STRING_DOT];
            }
        }
        
        if (textField.text.length == MAX_CODELENGTH)
        {
            [self scaleUpCode];
        }
        else
        {
            [btn_Proceed setBackgroundColor:RED_COLOR_WITHOPACITY];
            [btn_Proceed setUserInteractionEnabled:NO];
        }
    }
    else
    {
        for (NSInteger i = 0 ; i  < MAX_CODELENGTH ; i ++)
        {
            UILabel* focusedLabel = (UILabel* )[codeLblArray objectAtIndex:i];
            
            [focusedLabel setFont:FONT_DOT(codeFontSize-dotFontOffset)];
            
            [focusedLabel setText:STRING_DOT];
        }
        
        [btn_Proceed setBackgroundColor:RED_COLOR_WITHOPACITY];
        [btn_Proceed setUserInteractionEnabled:NO];
    }
}

// If the textField get the focus, then update the UI controls

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

// If the textField drop the focus, then update the UI controls

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (codeScaledFlag)
    {
        if (isScaling)
        {
            return NO;
        }
        
        isScaling = YES;
        
        scaleFactor = 1 / 1.3;
        
        CGPoint finalPoint = CGPointMake(gScreenSize.width / 2, panelNotifyLbl_Height.constant +  (confirmCodeView_Height.constant * scaleFactor ) /2);
        
        CGAffineTransform tr = CGAffineTransformScale(confirmCodeView.transform, scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:0
                         animations:^{
                             
                             confirmCodeView.transform = tr;
                             confirmCodeView.center = finalPoint;
                             
                         } completion:^(BOOL finished) {
                             
                             [self textFieldDidChange:textField];
                             
                             [panelNotifyLbl setHidden:NO];
                             [panelNotifyLbl setText:Alert1];
                             
                             isScaling = NO;
                             
                             codeScaledFlag = NO;
                             
                         }];
        return YES;
    }
    else
    {
        if (textField.text.length >= 6
            && range.length == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

@end

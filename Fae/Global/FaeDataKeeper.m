//
//  FaeDataKeeper.m
//  Fae
//
//  Created by Jesse on 2/25/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeDataKeeper.h"
#import "Constant.h"

@implementation FaeDataKeeper

#pragma mark - Camera Intro - 1 and 2

- (void)disableIntroViewed:(NSInteger)introIndex
{
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    if (introIndex == 1)
    {
        [userdefault setBool:NO forKey:Camera_Intro_1_Check];
    }
    else if (introIndex == 2)
    {
        [userdefault setBool:NO forKey:Camera_Intro_2_Check];
    }
    
    [userdefault synchronize];
}

- (void)updateIntroViewed:(NSInteger)introIndex
{
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    if (introIndex == 1)
    {
        [userdefault setBool:YES forKey:Camera_Intro_1_Check];
    }
    else if (introIndex == 2)
    {
        [userdefault setBool:YES forKey:Camera_Intro_2_Check];
    }
    
    [userdefault synchronize];
}

- (BOOL)passedInroView:(NSInteger)introIndex
{
    BOOL retVal = NO;
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    if (introIndex == 1)
    {
        if ([userdefault boolForKey:Camera_Intro_1_Check])
        {
            retVal = YES;
        }
    }
    else if (introIndex == 2)
    {
        if ([userdefault boolForKey:Camera_Intro_2_Check])
        {
            retVal = YES;
        }
    }
    
    return retVal;
}

@end

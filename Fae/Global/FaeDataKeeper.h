//
//  FaeDataKeeper.h
//  Fae
//
//  Created by Jesse on 2/25/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaeSingletonClass.h"

@interface FaeDataKeeper : FaeSingletonClass
{
    NSUserDefaults *m_pSetting;
}

#pragma mark - Camera Intro - 1 and 2

- (void)disableIntroViewed:(NSInteger)introIndex;
- (void)updateIntroViewed:(NSInteger)introIndex;
- (BOOL)passedInroView:(NSInteger)introIndex;


@end

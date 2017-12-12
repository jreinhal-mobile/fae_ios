//
//  FaeSingletonClass.m
//  Fae
//
//  Created by Jesse on 2/25/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeSingletonClass.h"

@implementation FaeSingletonClass

static FaeSingletonClass *sharedInstance = Nil;

// Get the shared instance and create it if necessary

+ (FaeSingletonClass*)sharedInstance
{
    if (sharedInstance == Nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the firest time
// MGH_SingletonClass is used.

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
    
}

// Your dealloc method will never be called, as the singleton survives for
// the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one
// day, I convert away from MGH_Singleton).
- (void)dealloc
{
    
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}


// Equally, we do not want ot generate multiple copies of the MGH_Sigleton.
- (id)copyWithZone:(NSZone* )zone
{
    return self;
}

@end

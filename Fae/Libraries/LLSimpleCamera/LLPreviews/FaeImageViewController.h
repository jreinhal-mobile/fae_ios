//
//  FaeImageViewController.h
//  Fae
//
//  Created by Jesse on 3/17/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaeImageViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImagePaths:(NSArray *)imagePaths;

@end

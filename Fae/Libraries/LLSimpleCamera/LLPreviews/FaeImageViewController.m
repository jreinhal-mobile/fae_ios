//
//  FaeImageViewController.m
//  Fae
//
//  Created by Jesse on 3/17/16.
//  Copyright (c) 2016 MGH Technologies Inc. All rights reserved.
//

#import "FaeImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "FaeAppDelegate.h"
#import "Constant.h"
#import "Global.h"

@interface FaeImageViewController ()

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSArray* imagePaths;
@property (strong, nonatomic) NSMutableArray* continousImages;

@property (strong, nonatomic) UIImageView*     circleOverlay;
@end

@implementation FaeImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (instancetype)initWithImagePaths:(NSArray *)imagePaths
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
//        _image = image;
        
        _imagePaths = imagePaths;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    self.imageView.image = self.image;
    
    if (self.imagePaths.count > 0)
    {
        self.continousImages = [[NSMutableArray alloc] init];
        
        for (NSInteger i = self.imagePaths.count ; i > 0 ; i --)
        {
            UIImage* singleImg = [UIImage imageWithContentsOfFile:[self.imagePaths objectAtIndex:(i-1)]];
            
            if (singleImg)
            {
                [self.continousImages addObject:singleImg];
            }
            
            if (i == self.imagePaths.count)
            {
                self.image = singleImg;
            }
        }
        
        self.imageView.animationImages = self.continousImages;
        self.imageView.animationDuration = 1.0;    // Show each captured photo for 5 seconds.
        self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
        [self.imageView startAnimating];
    }
    
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.infoLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = info;
    
//    [self.view addSubview:self.infoLabel];
    
    NSString *suffixStr = Nil;
    
    if (gDeviceType == DEVICE_IPHONE_35INCH)
    {
        suffixStr = @"4";
    }
    else if (gDeviceType == DEVICE_IPHONE_40INCH)
    {
        suffixStr = @"5";
    }
    else if (gDeviceType == DEVICE_IPHONE_47INCH)
    {
        suffixStr = @"6";
    }
    else if (gDeviceType == DEVICE_IPHONE_55INCH)
    {
        suffixStr = @"6p";
    }
    
    self.circleOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.circleOverlay.contentMode = UIViewContentModeScaleToFill;
    self.circleOverlay.backgroundColor = [UIColor clearColor];
    
    [self.circleOverlay setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera_overlay_circle_%@", suffixStr]]];
    
//    [self.view addSubview:self.circleOverlay];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.imageView.frame = self.view.contentBounds;
    
    [self.infoLabel sizeToFit];
    self.infoLabel.width = self.view.contentBounds.size.width;
    self.infoLabel.top = 0;
    self.infoLabel.left = 0;
    
    self.circleOverlay.frame = self.view.contentBounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

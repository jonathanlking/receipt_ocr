//
//  ViewController.m
//  partition_demo
//
//  Created by Jonathan King on 29/02/2016.
//  Copyright © 2016 Jonathan King. All rights reserved.
//

#import "ViewController.h"
#import "ImagePartition.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (nonatomic, strong) NSSet *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create the ImagePartition(er)
    ImagePartition *partitioner
        = [[ImagePartition alloc] initWithImage:[UIImage imageNamed:@"sainsbury.png"]];
    
    // Partition the image and populate a UIScrollView with its children
    _images = [partitioner partitionToimages];
    [self populateImageScrollView];
}

- (void)populateImageScrollView {
    
    // Hard code to be 100x100 px
    CGSize imageViewSize = CGSizeMake(100, 100);
    CGFloat verticalPadding = 20.0f;
    CGFloat y = 0;

    for (UIImage *image in _images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setFrame:CGRectMake(0, y, imageViewSize.width, imageViewSize.height)];
        [_imagesScrollView addSubview:imageView];
        y += verticalPadding + imageViewSize.height;
    }
    
    [_imagesScrollView setContentSize:CGSizeMake(imageViewSize.width, y)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

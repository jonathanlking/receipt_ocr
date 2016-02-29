//
//  ImagePartition.m
//  partition_demo
//
//  Created by Jonathan King on 29/02/2016.
//  Copyright © 2016 Jonathan King. All rights reserved.
//

#import "ImagePartition.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ImagePartition()
@property (nonatomic, strong) UIImage *image;
@end

@implementation ImagePartition : NSObject 

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        // Perform setup here
        _image = image;
        NSLog(@"Impage partition create");
    }
    return self;
}

- (NSSet *)partitionToimages {
    // partition the image
    return nil;
}

@end
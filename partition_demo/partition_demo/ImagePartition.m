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
    }
    return self;
}

- (NSSet *)partitionToimages {
    // partition the image
    NSSet *images = [[NSSet alloc] initWithObjects:_image, nil];
    return images;
}

@end
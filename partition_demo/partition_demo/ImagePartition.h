//
//  ImagePartition.h
//  partition_demo
//
//  Created by Jonathan King on 29/02/2016.
//  Copyright © 2016 Jonathan King. All rights reserved.
//

#ifndef ImagePartition_h
#define ImagePartition_h

#import <UIKit/UIKit.h>

@interface ImagePartition : NSObject
- (instancetype)initWithImage:(UIImage *)image;

// Synchronously calculates the sub images and returns a set of UIImages
- (NSSet *)partitionToimages;
@end

#endif /* ImagePartition_h */

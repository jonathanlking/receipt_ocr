//
//  ImagePartition.m
//  partition_demo
//
//  Created by Jonathan King on 29/02/2016.
//  Copyright © 2016 Jonathan King. All rights reserved.
//

#import "ImagePartition.h"
#import <CoreGraphics/CoreGraphics.h>

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8((x) >> 8 ) )
#define B(x) ( Mask8((x) >> 16) )
#define A(x) ( Mask8((x) >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

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
    
    // the limit to treat as black
    int threshold = [self processImage];
    
    NSArray *vertical = [self verticalStrips:threshold];
    NSLog(@"%@", vertical);
    
    NSSet *images = [[NSSet alloc] initWithObjects:_image, nil];
    return images;
}

- (int)processImage {
    
    const int colour_space = 2 << 7;
    int *histogram = (int *)calloc(colour_space, (sizeof(int)));
    
    // Load image pixels into inputPixels array
    CGImageRef inputCGImage = [_image CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    UInt32 *inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    for (int j = 0; j < inputHeight; j++) {
        for (int i = 0; i < inputWidth; i++) {
            
            UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            
            // Choose the minimum
            UInt32 minColour = MIN(MIN(R(color), G(color)), B(color));
            histogram[minColour]++;
        }
    }
    
    // Somehow determine the threshold value
    
//    for (int i = 0; i < colour_space; i++) {
//        printf("%d ", histogram[i]);
//    }
    
    free(histogram);
    return 40; // hard coded at 40 for now
}

- (NSArray *)verticalStrips:(int)threshold {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Load image pixels into inputPixels array
    CGImageRef inputCGImage = [_image CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    UInt32 *inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    
    int *rowCount = (int *)calloc(inputHeight, (sizeof(int)));
    
    for (int j = 0; j < inputHeight; j++) {
        for (int i = 0; i < inputWidth; i++) {
            
            UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            
            // Choose the minimum
            UInt32 minColour = MIN(MIN(R(color), G(color)), B(color));
            if (minColour < threshold) {
               rowCount[j]++;
            }
        }
    }
    
    for (int i = 0; i < inputHeight; i++) {
        printf("%d ", rowCount[i]);
    }
    
    // Find the start and end pixels for the rows
    
    NSUInteger start = 0;
    NSUInteger end = 0;
    
    for (int i = 0; i < inputHeight; i++) {
        if (rowCount[i] == 0) {
            // if beggining, then start < end
            if (start >= end) {
                start = i + 1; // This row is empty, so provisionally set the start as the next row
            } else {
                end = i;
                NSRange range = NSMakeRange(start, end - start);
                [array addObject:[NSValue valueWithRange:range]];
                start = i + 1; // Provisionally set the start as the next row
            }
        } else {
            end += 1;
        }
    }
    
    // Perform fancy analysis to only include rows which are similar to the mean height
    
    free(rowCount);
    
    return array;
}

@end
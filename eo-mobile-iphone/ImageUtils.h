//
//  ImageUtils.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 29/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

//No image thumbnail
+ (NSString*)noImageThumb;

//This method scales and crop image for the specified size
+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)image:(CGSize)targetSize;

//This method only scales the image to the specified size, without cropping it
+ (UIImage*)scaleToSize:(UIImage*)image:(CGSize)size;

@end

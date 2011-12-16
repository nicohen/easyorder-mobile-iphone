//
//  Category.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject {
    NSString* name;
    NSNumber* quantity;
}

@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSNumber* quantity;

@end

//
//  StoreAlertsDelegate.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReachabilityService.h"

@protocol StoreAlertsDelegate <RKObjectLoaderDelegate>
@end

@interface StoreAlertsDelegate : NSObject {
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects;
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;

@end

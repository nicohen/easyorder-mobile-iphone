//
//  ReachabilityService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface ReachabilityService : NSObject {
    RKReachabilityObserver* _observer;
    BOOL isNetworkServiceAvailable;
}

+ (ReachabilityService *)sharedService;
- (BOOL)isNetworkServiceAvailable;
- (void)notifyNetworkUnreachable;
- (void)setup;

@end

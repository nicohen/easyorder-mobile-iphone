//
//  StoreAlertsDelegate.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreAlertsDelegate.h"

@implementation StoreAlertsDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Anduvo!" message:@"Yahooo!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error realizando llamada" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

@end

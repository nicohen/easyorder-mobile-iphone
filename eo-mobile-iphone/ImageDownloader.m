//
//  ImageCache.m
//  Hunting Web
//
//  Created by Nicolás Cohen on 25/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"
#import "ImageUtils.h"

@implementation ImageDownloader

@synthesize indexPathInTableView, delegate, activeDownload, imageConnection, object, imageUrl;

#pragma mark

- (void)dealloc {
    [imageUrl release];
    [indexPathInTableView release];
    [activeDownload release];
    [imageConnection cancel];
    [imageConnection release];
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:imageUrl]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    statusCode = [((NSHTTPURLResponse *)response) statusCode];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    [delegate appImageDidFailLoad:self.indexPathInTableView];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *newImage = [[UIImage alloc] initWithData:self.activeDownload];
    
    if((imageUrl == nil) || statusCode != 200) {
        self.object.image = [UIImage imageNamed:[ImageUtils noImageThumb]];
    } else {
        self.object.image = [ImageUtils imageByScalingAndCroppingForSize:newImage:CGSizeMake(80,80)];
    }
    [newImage release];
    
    self.activeDownload = nil;
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    if(statusCode != 200) {
        // call our delegate and tell it that our image is not ready for display
        [delegate appImageDidFailLoad:self.indexPathInTableView];
    } else {
        // call our delegate and tell it that our image is ready for display
        [delegate appImageDidLoad:self.indexPathInTableView];
    }
}

@end
//
//  ImageCache.h
//  Hunting Web
//
//  Created by Nicolás Cohen on 25/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObjectWithImage.h"

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject {
    NSString *imageUrl;
    NSObjectWithImage *object;
    NSIndexPath *indexPathInTableView;
    id <ImageDownloaderDelegate> delegate;
    
    int statusCode;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSObjectWithImage *object;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloaderDelegate <NSObject>

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)appImageDidFailLoad:(NSIndexPath *)indexPath;

@end
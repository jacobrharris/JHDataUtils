//
//  AIDataUtils.h
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloaderOperation.h"
#import "JHDataObject.h"

@protocol JHDataUtilsDelegate;

@interface JHDataUtils : NSObject <ImageDownloaderDelegate>

@property (assign) id <JHDataUtilsDelegate> delegate;

- (void)queueDownloadRequest:(NSURLRequest *)request delegate:(id)delegate;
- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate;
- (NSArray *)allPendingOperations;
- (id)pendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)removePendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;

@end


@protocol JHDataUtilsDelegate <NSObject>

- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithJSON:(NSDictionary *)json;
- (void)dataUtils:(JHDataUtils *)dataUtils didFailWithError:(NSError *)error;

- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithDataObject:(JHDataObject *)object;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithTableViewIndexPath:(NSIndexPath *)tvIndexPath collectionViewIndexPath:(NSIndexPath *)cvIndexPath;

@end
//
//  AIDataUtils.h
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHDataRequest.h"
#import "JHCache.h"
#import "ImageDownloaderOperation.h"

@protocol JHDataUtilsDelegate;

@interface JHDataUtils : NSObject <ImageDownloaderDelegate>

@property (weak, nonatomic) id <JHDataUtilsDelegate> delegate;

// Downloading
- (void)queueDownloadRequest:(JHDataRequest *)request delegate:(id<JHDataUtilsDelegate>)delegate;
- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id<JHDataUtilsDelegate>)delegate;
- (void)startImageDownloadingForURLs:(NSDictionary *)urls atIndexPath:(NSIndexPath *)indexPath delegate:(id<JHDataUtilsDelegate>)delegate;
- (NSArray *)allPendingOperations;
- (id)pendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)removePendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;
@property (nonatomic, readonly, getter=isSuspended) BOOL suspended;

// Caching
@property (strong, nonatomic, readonly) JHCache *caching;

@end


@protocol JHDataUtilsDelegate <NSObject>

@required
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithJSON:(NSDictionary *)json;

@optional
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithImage:(UIImage *)image withKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithTableViewIndexPath:(NSIndexPath *)tvIndexPath collectionViewIndexPath:(NSIndexPath *)cvIndexPath;

@end
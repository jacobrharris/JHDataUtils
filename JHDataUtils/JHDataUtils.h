//
//  AIDataUtils.h
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCache.h"
#import "ImageDownloaderOperation.h"
#import "PendingOperations.h"

typedef NS_ENUM(NSInteger, JHDataUtilsNetworkStatus) {
    JHDataUtilsNetworkStatusDown = 0,
    JHDataUtilsNetworkStatusUp = 1
};

@protocol JHDataUtilsDelegate;

@interface JHDataUtils : NSObject <ImageDownloaderDelegate>

extern NSString * const JHDataUtilsNetworkStatusDidChangeNotification;
extern NSString * const JHDataUtilsNetworkStatusNotificationItem;
extern NSString * const JHDataUtilsNetworkRequestDidFailNotification;
extern NSString * const JHDataUtilsNetworkRequestNotificationItem;
extern NSString * const JHBackgroundSessionDownloadDidFinishNotification;

@property (nonatomic, copy) void (^savedCompletionHandler)(void);
@property (weak, nonatomic) id <JHDataUtilsDelegate> delegate;
@property (nonatomic, readonly) JHDataUtilsNetworkStatus currentNetworkStatus;

+ (JHDataUtils *)sharedDataUtils;

// Downloading
- (void)queueDownloadRequest:(NSURLRequest *)request delegate:(id)delegate;
- (void)queueBackgroundDownloadRequest:(NSURLRequest *)request;
- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate;
- (void)startImageDownloadingForURLs:(NSDictionary *)urls atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate;

// Pending operations
- (NSArray *)allPendingOperations;
- (PendingOperations *)pendingOperations;
- (id)pendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)removePendingOperationAtIndexPath:(NSIndexPath *)indexPath;
- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;

// Caching
@property (strong, nonatomic, readonly) JHCache *caching;

@end


@protocol JHDataUtilsDelegate <NSObject>

@optional
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishBackgroundDownloadWithJSON:(NSDictionary *)json;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithJSON:(NSDictionary *)json;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithImage:(UIImage *)image withKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFailWithError:(NSError *)error;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithTableViewIndexPath:(NSIndexPath *)tvIndexPath collectionViewIndexPath:(NSIndexPath *)cvIndexPath;

@end
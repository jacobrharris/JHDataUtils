//
//  AIDataUtils.m
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import "JHDataUtils.h"
#import "JHDownloadOperation.h"
#import "AFNetworking.h"

NSString *const JHDataUtilsNetworkStatusDidChangeNotification = @"com.jhdatautils.network-status.change";
NSString *const JHDataUtilsNetworkStatusNotificationItem = @"JHDataUtilsNetworkStatusNotificationItem";
NSString *const JHDataUtilsNetworkRequestDidFailNotification = @"com.jhdatautils.network-request.fail";
NSString *const JHDataUtilsNetworkRequestNotificationItem = @"JHDataUtilsNetworkRequestNotificationItem";

@interface JHDataUtils () <JHDownloadOperationDelegate>
@end

@implementation JHDataUtils {
    PendingOperations *_pendingOperations;
    AFNetworkReachabilityManager *_reachabilityManager;
}

#define apiKey @"abcd1234"

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager startMonitoring];
    }

    return self;
}

// TODO: Make a singleton
//+ (instancetype)sharedDataUtils
//{
//    static JHDataUtils *utils = nil;
//    if (utils == nil) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            utils = [[self alloc] init];
//            [[NSNotificationCenter defaultCenter] addObserver:utils selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
//            AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
//            [reachabilityManager startMonitoring];
//            NSLog(@"reachabilityManager: %@", reachabilityManager);
//        });
//    }
//    
//    return utils;
//}

- (JHDataUtilsNetworkStatus)currentNetworkStatus
{
    switch (_reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return JHDataUtilsNetworkStatusUp;
            
        case AFNetworkReachabilityStatusNotReachable:
            return JHDataUtilsNetworkStatusDown;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return JHDataUtilsNetworkStatusUp;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return JHDataUtilsNetworkStatusUp;
            
        // ?
        default:
            return JHDataUtilsNetworkStatusDown;
    }
}
 
- (void)reachabilityDidChange:(id)sender
{
    JHDataUtilsNetworkStatus networkStatus = [self currentNetworkStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:JHDataUtilsNetworkStatusDidChangeNotification object:nil userInfo:@{JHDataUtilsNetworkStatusNotificationItem:@(networkStatus)}];
}

- (void)queueDownloadRequest:(NSURLRequest *)request delegate:(id)delegate {
    JHDownloadOperation *downloadOperation = [[JHDownloadOperation alloc] initWithRequest:request];
    downloadOperation.delegate = self;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.pendingOperations.downloadQueue addOperation:downloadOperation];
}

- (void)downloadOperationDidFinish:(JHDownloadOperation *)downloadOperation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    id <JHDataUtilsDelegate> delegate = self.delegate;
    [delegate dataUtils:self didFinishWithJSON:downloadOperation.json];
}

- (void)downloadOperationDidFail:(JHDownloadOperation *)downloadOperation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Just die silently if the error is due to the operation being cancelled.
    if (!downloadOperation.isCancelled) {
        id <JHDataUtilsDelegate> delegate = self.delegate;
        [delegate dataUtils:self didFailWithError:downloadOperation.error];
    }
}

- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate
{
    ImageDownloaderOperation *imageDownloader = [[ImageDownloaderOperation alloc] initWithURL:url atIndexPath:indexPath delegate:self];
    [self.pendingOperations.downloadQueue addOperation:imageDownloader];
}

- (void)startImageDownloadingForURLs:(NSDictionary *)urls atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate
{
    for (NSString *key in urls) {
        ImageDownloaderOperation *imageDownloader = [[ImageDownloaderOperation alloc] initWithURL:[urls valueForKey:key] withKey:key atIndexPath:indexPath delegate:delegate];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(ImageDownloaderOperation *)downloader
{
    id <JHDataUtilsDelegate> delegate = self.delegate;
    NSIndexPath *indexPath = downloader.indexPath;
    [delegate dataUtils:self didFinishWithImage:downloader.image withKey:downloader.imageKey atIndexPath:indexPath];
}

- (PendingOperations *)pendingOperations
{
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
}

- (NSArray *)allPendingOperations
{
    return [self.pendingOperations.downloadsInProgress allKeys];
}

- (id)pendingOperationAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
}

- (void)removePendingOperationAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

- (void)suspendAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:YES];
}

- (void)resumeAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
    [self.pendingOperations cancelAllOperations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

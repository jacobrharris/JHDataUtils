//
//  AIDataUtils.m
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import "JHDataUtils.h"
#import "PendingOperations.h"
#import "AFNetworking.h"

@implementation JHDataUtils {
    PendingOperations *_pendingOperations;
}

#define apiKey @"abcd1234"

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}

- (void)reachabilityChanged:(id)sender
{
    NSNotification *notification = (NSNotification *)sender;
    NSDictionary *info = notification.userInfo;
    NSInteger status = [[info objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    BOOL reachable = status > 0;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reachabilityDidChangeWithInfo" object:self userInfo:@{@"reachability":[NSNumber numberWithBool:reachable]}];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reachabilityDidChangeWithInfo" object:self userInfo:@{@"reachability":[NSNumber numberWithInteger:status]}];
}

- (void)operationDidFinish:(AFHTTPRequestOperation *)operation
{
    if (operation.error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkRequestDidFailWithInfo" object:self userInfo:@{@"operation":operation, @"error":operation.error}];
    }
}

- (void)queueDownloadRequest:(JHDataRequest *)request delegate:(id<JHDataUtilsDelegate>)delegate
{
    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request.request];
    datasource_download_operation.responseSerializer = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)datasource_download_operation.responseSerializer).removesKeysWithNullValues = YES;
    datasource_download_operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"]; // NOT SURE IF THIS IS NEEDED
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if (!json) {
            [delegate dataUtils:self didFinishWithJSON:nil];
        } else {
            [delegate dataUtils:self didFinishWithJSON:json];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self operationDidFinish:operation];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self operationDidFinish:operation];
    }];

    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
}

- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id<JHDataUtilsDelegate>)delegate
{
    ImageDownloaderOperation *imageDownloader = [[ImageDownloaderOperation alloc] initWithURL:url atIndexPath:indexPath delegate:self];
    [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
    [self.pendingOperations.downloadQueue addOperation:imageDownloader];
}

- (void)startImageDownloadingForURLs:(NSDictionary *)urls atIndexPath:(NSIndexPath *)indexPath delegate:(id<JHDataUtilsDelegate>)delegate
{
    for (NSString *key in urls) {
        ImageDownloaderOperation *imageDownloader = [[ImageDownloaderOperation alloc] initWithURL:[urls valueForKey:key] withKey:key atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(ImageDownloaderOperation *)downloader
{
    id <JHDataUtilsDelegate> delegate = self.delegate;
    NSIndexPath *indexPath = downloader.indexPath;
    [delegate dataUtils:self didFinishWithImage:downloader.image withKey:downloader.imageKey atIndexPath:indexPath];
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
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
    [self.pendingOperations.downloadQueue cancelAllOperations];
}

- (BOOL)isSuspended
{
    return _pendingOperations.downloadQueue.suspended;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
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

- (void)queueDownloadRequest:(NSURLRequest *)request delegate:(id)delegate
{
    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    datasource_download_operation.responseSerializer = [AFJSONResponseSerializer serializer];
    datasource_download_operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"]; // NOT SURE IF THIS IS NEEDED
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if (!json) {
            [delegate dataUtils:self didFinishWithJSON:nil];
        } else {
            [delegate dataUtils:self didFinishWithJSON:json];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [delegate dataUtils:self didFailWithError:error];
    }];
    
    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
}

- (void)startImageDownloadingForURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id)delegate
{
    ImageDownloaderOperation *imageDownloader = [[ImageDownloaderOperation alloc] initWithURL:url atIndexPath:indexPath delegate:self];
    [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
    [self.pendingOperations.downloadQueue addOperation:imageDownloader];
}

- (void)imageDownloaderDidFinish:(ImageDownloaderOperation *)downloader
{
    id <JHDataUtilsDelegate> delegate = self.delegate;
    NSIndexPath *indexPath = downloader.indexPath;
    [delegate dataUtils:self didFinishWithImage:downloader.image atIndexPath:downloader.indexPath];
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

@end

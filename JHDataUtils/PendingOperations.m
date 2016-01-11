//
//  PendingOperations.m
//  ai-aggregator
//
//  Created by Jacob Harris on 8/29/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"downloadsInProgress: %@\ndownloadQueue: %@", [self downloadsInProgress], [self downloadQueue].operations];
    return description;
}

- (NSMutableDictionary *)downloadsInProgress
{
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue
{
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}

- (void)cancelAllOperations {
    [_downloadQueue cancelAllOperations];
}

@end

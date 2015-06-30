//
//  JHDataRequest.m
//  JHDataUtils
//
//  Created by Jacob Harris on 6/27/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import "JHDataRequest.h"

@implementation JHDataRequest {
    NSIndexPath *_dataIndexPath;
}

- (instancetype)initWithRequest:(NSURLRequest *)request id:(NSString *)requestID delegate:(id<JHDataRequestDelegate>)delegate
{
    if (!requestID || [requestID isEqualToString:@""]) {
        return nil;
    }
    
    if (self = [super init]) {
        _request = request;
        _dataRequestID = requestID;
        _delegate = delegate;
    }
    
    return self;
}

- (NSIndexPath *)dataIndexPath
{
    return _dataIndexPath;
}

- (void)setDataIndexPath:(NSIndexPath *)indexPath
{
    _dataIndexPath = indexPath;
}

@end
//
//  JHDownloadOperation.m
//  JHDataUtils
//
//  Created by Jacob Harris on 1/10/16.
//  Copyright © 2016 Jacob Harris. All rights reserved.
//

#import "JHDownloadOperation.h"

@implementation JHDownloadOperation

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    if (self = [super initWithRequest:urlRequest]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)self.responseSerializer).removesKeysWithNullValues = YES;
    [self.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"text/html"]];
    
    __weak JHDownloadOperation *weakSelf = self;
    [self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = (NSDictionary *)responseObject;
        _json = json;
        [weakSelf.delegate downloadOperationDidFinish:weakSelf];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.delegate downloadOperationDidFail:weakSelf];
    }];
}

- (void)cancel {
    [super cancel];
    
    NSLog(@"Cancelled! %@", self);
}

@end
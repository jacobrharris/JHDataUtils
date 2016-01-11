//
//  JHDownloadOperation.h
//  JHDataUtils
//
//  Created by Jacob Harris on 1/10/16.
//  Copyright © 2016 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol JHDownloadOperationDelegate;

@interface JHDownloadOperation : AFHTTPRequestOperation

@property (weak, nonatomic) id <JHDownloadOperationDelegate> delegate;
@property (strong, nonatomic) NSDictionary *json;

@end

@protocol JHDownloadOperationDelegate <NSObject>

- (void)downloadOperationDidFinish:(JHDownloadOperation *)downloadOperation;
- (void)downloadOperationDidFail:(JHDownloadOperation *)downloadOperation;

@end
//
//  JHDataRequest.h
//  JHDataUtils
//
//  Created by Jacob Harris on 6/27/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JHDataRequestDelegate;

@interface JHDataRequest : NSObject

- (instancetype)initWithRequest:(NSURLRequest *)request id:(NSString *)requestID delegate:(id<JHDataRequestDelegate>)delegate;

@property (weak, nonatomic) id <JHDataRequestDelegate> delegate;
@property (strong, nonatomic, readonly) NSURLRequest *request;
@property (strong, nonatomic, readonly) NSIndexPath *dataIndexPath;
@property (strong, nonatomic, readonly) NSString *dataRequestID;

@end

@protocol JHDataRequestDelegate <NSObject>

<#methods#>

@end
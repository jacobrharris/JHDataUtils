//
//  JHBackgroundSessionManager.h
//  JHDataUtils
//
//  Created by Jacob Harris on 2/11/16.
//  Copyright © 2016 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@protocol JHBackgroundSessionDelegate;

@interface JHBackgroundSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
@property (weak, nonatomic) id <JHBackgroundSessionDelegate> delegate;
@property (nonatomic, copy) void (^savedCompletionHandler)(void);

@end

@protocol JHBackgroundSessionDelegate <NSObject>

- (void)backgroundDownloadTaskDidFinishWithJSON:(id)json;

@end
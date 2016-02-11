//
//  JHBackgroundSessionManager.m
//  JHDataUtils
//
//  Created by Jacob Harris on 2/11/16.
//  Copyright © 2016 Jacob Harris. All rights reserved.
//


// SOLUTION:
// http://stackoverflow.com/questions/21350125/afnetworking-2-0-and-background-transfers


#import "JHBackgroundSessionManager.h"

NSString * const JHBackgroundSessionIdentifier = @"com.jhdatautils.backgroundsession";

@implementation JHBackgroundSessionManager

+ (instancetype)sharedManager {
    static id mySharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedManager = [[self alloc] init];
    });
    
    return mySharedManager;
}

- (instancetype)init {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:JHBackgroundSessionIdentifier];
    if (self = [super initWithSessionConfiguration:config]) {
        [self configureDownloadFinished];
        [self configureBackgroundSessionFinished];
    }
    
    return self;
}

- (void)configureDownloadFinished {
    typeof(self) __weak weakSelf = self;
    
    [self setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        if ([downloadTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)downloadTask.response statusCode];
            if (statusCode != 200) {
                NSLog(@"%@ Background download failed with status code %ld", [downloadTask.originalRequest.URL lastPathComponent], (long)statusCode);
                return nil;
            }

            // Get the json from the downloaded file
            NSData *data = [NSData dataWithContentsOfURL:location];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            id jsonCleaned = [weakSelf JSONObjectByRemovingKeysWithNullValuesFromObject:json];
            
            id <JHBackgroundSessionDelegate> delegate = weakSelf.delegate;
            [delegate backgroundDownloadTaskDidFinishWithJSON:jsonCleaned];
        }
        
        return downloadTask.originalRequest.URL;
    }];
    
    [self setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@: %@", [task.originalRequest.URL lastPathComponent], error);
        }
    }];
}

- (void)configureBackgroundSessionFinished {
    typeof(self) __weak weakSelf = self;
    
    [self setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.savedCompletionHandler) {
            weakSelf.savedCompletionHandler();
            weakSelf.savedCompletionHandler = nil;
        }
    }];
}

- (id)JSONObjectByRemovingKeysWithNullValuesFromObject:(id)JSONObject {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:[self JSONObjectByRemovingKeysWithNullValuesFromObject:value]];
        }
        return mutableArray ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = [(NSDictionary *)JSONObject objectForKey:key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [mutableDictionary setObject:[self JSONObjectByRemovingKeysWithNullValuesFromObject:value] forKey:key];
            }
        }
        
        return mutableDictionary ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}

@end

//
//  JHCache.h
//  JHDataUtils
//
//  Created by Jacob Harris on 4/16/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHDataContainer.h"

typedef NS_ENUM(NSInteger, DataStaleness) {
    DataStalenessFresh = 0,
    DataStalenessStale = 1
};

@interface JHCache : NSObject

+ (void)cacheDataContainer:(JHDataContainer *)dataContainer;
+ (JHDataContainer *)loadCachedDataContainerForKey:(NSString *)key;

+ (void)resetAllCaches;
+ (void)resetCacheForKey:(NSString *)key;

+ (DataStaleness)dataStalenessStatusForKey:(NSString *)key maxAllowedTime:(NSTimeInterval)allowedTime;

@end
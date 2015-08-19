//
//  JHCache.m
//  JHDataUtils
//
//  Created by Jacob Harris on 4/16/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import "JHCache.h"

@implementation JHCache

+ (void)cacheDataContainer:(JHDataContainer *)dataContainer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataContainer];
    NSString *containerKey = [JHCache dataContainerKeyForString:dataContainer.containerName];

    [defaults setObject:data forKey:containerKey];
    if ([defaults synchronize]) {
        NSLog(@"Saved %@ to disk.", dataContainer.containerName);
    } else {
        NSLog(@"Could not save %@ to disk.", dataContainer.containerName);
    }
}

+ (JHDataContainer *)loadCachedDataContainerForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *containerKey = [JHCache dataContainerKeyForString:key];
    NSData *data = [defaults objectForKey:containerKey];
    
    [NSKeyedUnarchiver setClass:[JHDataContainer class] forClassName:@"JHDataContainer"];
    JHDataContainer *dataContainer = (JHDataContainer *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (dataContainer) {
        NSLog(@"Loaded %@ from disk", dataContainer.containerName);
    } else {
        NSLog(@"No stored data to load.");
    }
    
    return dataContainer;
}

+ (void)resetAllCaches
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultsDict = [defaults dictionaryRepresentation];

    for (id key in defaultsDict) {
        [defaults removeObjectForKey:key];
    }

    [defaults synchronize];
    
    NSLog(@"Reset all caches");
}

+ (void)resetCacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *containerKey = [JHCache dataContainerKeyForString:key];
    [defaults removeObjectForKey:containerKey];
    [defaults synchronize];
    
    NSLog(@"Reset cache for key: %@", key);
}

+ (DataStaleness)dataStalenessStatusForKey:(NSString *)key maxAllowedTime:(NSTimeInterval)allowedTime
{
    JHDataContainer *dataContainer = [JHCache loadCachedDataContainerForKey:key];
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:dataContainer.timestamp]; // in seconds

    if (elapsedTime > allowedTime) { // data is stale
        NSLog(@"Data is stale. Time to refresh.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessStale;
    } else if (elapsedTime <= allowedTime) { // data is fresh
        NSLog(@"Data is fresh.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessFresh;
    } else if (isnan(elapsedTime)) { // first launch (consider data stale)
        NSLog(@"First launch. No stored data.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessStale;
    } else {
        return DataStalenessStale;
    }
}

+ (NSString *)dataContainerKeyForString:(NSString *)string
{
    NSString *suffix = @"_container";
    return [NSString stringWithFormat:@"%@%@", string, suffix]; // i.e. UserData --> UserData_container
}

+ (NSString *)timestampName
{
    return @"timestamp";
}

@end
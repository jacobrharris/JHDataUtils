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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *containerKey = [JHCache dataContainerKeyForString:key];
    NSData *data = [userDefaults objectForKey:containerKey];
    JHDataContainer *dataContainer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
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
}

+ (void)resetCacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (DataStaleness)dataStalenessStatusForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *container = [defaults objectForKey:key];
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:[container valueForKey:@"lastUpdated"]]; // in seconds
    NSInteger maxAllowedTime = 20; // in seconds

    if (elapsedTime > maxAllowedTime) { // data is stale
        NSLog(@"Data is stale. Time to refresh.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessStale;
    } else if (elapsedTime <= maxAllowedTime) { // data is fresh
        NSLog(@"Data is fresh.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessFresh;
    } else if (isnan(elapsedTime)) { // first launch (consider data fresh)
        NSLog(@"First launch. No stored data.");
        NSLog(@"%f", elapsedTime);
        return DataStalenessFresh;
    } else {
        return 0;
    }
}

+ (NSString *)dataContainerKeyForString:(NSString *)string
{
    NSString *suffix = @"_container";
    return [NSString stringWithFormat:@"%@%@", string, suffix]; // i.e. UserData --> UserData_container
}

+ (NSString *)timestampName
{
    return @"last_updated";
}

@end
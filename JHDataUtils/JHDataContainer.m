//
//  JHDataContainer.m
//  JHDataUtils
//
//  Created by Jacob Harris on 4/16/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import "JHDataContainer.h"

@implementation JHDataContainer

- (instancetype)initWithContainerName:(NSString *)containerName data:(NSData *)data
{
    if (self = [super init]) {
        _containerName = containerName;
        _data = data;
        _timestamp = [NSDate date];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _containerName = [decoder decodeObjectForKey:@"container_name"];
        _timestamp = [decoder decodeObjectForKey:@"timestamp"];
        _data = [decoder decodeObjectForKey:@"data"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_containerName forKey:@"container_name"];
    [coder encodeObject:_timestamp forKey:@"timestamp"];
    [coder encodeObject:_data forKey:@"data"];
}

@end
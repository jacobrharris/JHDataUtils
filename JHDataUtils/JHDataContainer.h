//
//  JHDataContainer.h
//  JHDataUtils
//
//  Created by Jacob Harris on 4/16/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHDataContainer : NSObject <NSCoding>

- (instancetype)initWithContainerName:(NSString *)containerName data:(NSData *)data;

@property (strong, nonatomic, readonly) NSString *containerName;
@property (strong, nonatomic, readonly) NSDate *timestamp;
@property (strong, nonatomic, readonly) NSData *data;

@end
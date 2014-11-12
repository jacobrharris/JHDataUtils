//
//  JHDataObject.h
//  JHDataUtils
//
//  Created by Jacob Harris on 11/11/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHDataObject : NSObject

- (id)initWithData:(id)data fromRequest:(NSURLRequest *)request;
- (NSDictionary *)allData;

@end

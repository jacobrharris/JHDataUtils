//
//  JHDataObject.m
//  JHDataUtils
//
//  Created by Jacob Harris on 11/11/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import "JHDataObject.h"

@implementation JHDataObject {
    NSURLRequest *_requestObject;
    id _responseObject;
    NSDictionary *_jsonDict;
}

- (id)initWithData:(id)data fromRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        _jsonDict = [self jsonifyData:data];
    }
    
    return self;
}

- (NSDictionary *)jsonifyData:(id)data
{
    NSError *error;
    NSDictionary *jsonSerialized = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:jsonSerialized, @"json", error, @"error", nil];

    return jsonDict;
}

- (NSDictionary *)allData
{
    NSDictionary *everything = [NSDictionary dictionaryWithObjectsAndKeys:_requestObject, @"requestObject", _responseObject, @"responseObject", _jsonDict, @"json", nil];
    return everything;
}

@end

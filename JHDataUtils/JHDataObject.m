//
//  JHDataObject.m
//  JHDataUtils
//
//  Created by Jacob Harris on 11/11/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import "JHDataObject.h"
#import "AFNetworking.h"

@implementation JHDataObject {
    NSURLRequest *_requestObject;
    NSHTTPURLResponse *_responseObject;
    NSDictionary *_jsonDict;
}

- (id)initWithOperation:(AFHTTPRequestOperation *)operation
{
    if (self = [super init]) {
        _requestObject = [operation request];
        _responseObject = [operation response];
        _jsonDict = [self jsonifyData:[operation responseData]];
        
        if (!_jsonDict) {
            return nil;
        }
    }
    
    return self;
}

- (NSDictionary *)jsonifyData:(NSData *)data
{
    NSError *error;
    NSDictionary *jsonSerialized = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    return jsonSerialized;
}

- (NSDictionary *)allData
{
    NSDictionary *everything = [NSDictionary dictionaryWithObjectsAndKeys:_requestObject, @"requestObject", _responseObject, @"responseObject", _jsonDict, @"json", nil];
    return everything;
}

- (NSURLRequest *)request
{
    return _requestObject;
}

- (NSHTTPURLResponse *)response
{
    return _responseObject;
}

- (NSDictionary *)json
{
    return _jsonDict;
}

@end

//
//  AIDataUtils.h
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHDataObject.h"

@protocol JHDataUtilsDelegate;

@interface JHDataUtils : NSObject

@property (weak, nonatomic) id <JHDataUtilsDelegate> delegate;

- (void)queueDownloadRequest:(NSURLRequest *)request delegate:(id)delegate;
- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;

@end


@protocol JHDataUtilsDelegate <NSObject>

- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithDataObject:(JHDataObject *)object;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(JHDataUtils *)dataUtils didFinishWithTableViewIndexPath:(NSIndexPath *)tvIndexPath collectionViewIndexPath:(NSIndexPath *)cvIndexPath;

@end
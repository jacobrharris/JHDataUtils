//
//  AIDataUtils.h
//  ai-aggregator
//
//  Created by Jacob Harris on 9/15/14.
//  Copyright (c) 2014 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PendingOperations.h"
#import "JHDataObject.h"

@protocol AIDataUtilsDelegate;

@interface AIDataUtils : NSObject

@property (weak, nonatomic) id <AIDataUtilsDelegate> delegate;
@property (strong, nonatomic) PendingOperations *pendingOperations;

- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;

@end


@protocol AIDataUtilsDelegate <NSObject>

- (void)dataUtils:(AIDataUtils *)dataUtils didFinishWithDataObject:(JHDataObject *)object;
- (void)dataUtils:(AIDataUtils *)dataUtils didFinishWithIndexPath:(NSIndexPath *)indexPath;
- (void)dataUtils:(AIDataUtils *)dataUtils didFinishWithTableViewIndexPath:(NSIndexPath *)tvIndexPath collectionViewIndexPath:(NSIndexPath *)cvIndexPath;

@end
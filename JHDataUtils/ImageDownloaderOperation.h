//
//  ImageDownloaderOperation.h
//  JHDataUtils
//
//  Created by Jacob Harris on 2/1/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageDownloaderDelegate;

@interface ImageDownloaderOperation : NSOperation

- (instancetype)initWithURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)delegate;
- (instancetype)initWithURL:(NSURL *)url withKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)delegate;

@property (weak, nonatomic) id <ImageDownloaderDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *imageKey;
@property (strong, nonatomic) UIImage *image;

@end


@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloaderDidFinish:(ImageDownloaderOperation *)downloader;

@end
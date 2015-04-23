//
//  ImageDownloaderOperation.m
//  JHDataUtils
//
//  Created by Jacob Harris on 2/1/15.
//  Copyright (c) 2015 Jacob Harris. All rights reserved.
//

#import "ImageDownloaderOperation.h"

@implementation ImageDownloaderOperation

- (instancetype)initWithURL:(NSURL *)url atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _indexPath = indexPath;
        _imageURL = url;
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url withKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _indexPath = indexPath;
        _imageURL = url;
        _imageKey = key;
    }

    return self;
}

- (void)main
{
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            if (downloadedImage) {
                _image = downloadedImage;
            }
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
    }
}

@end
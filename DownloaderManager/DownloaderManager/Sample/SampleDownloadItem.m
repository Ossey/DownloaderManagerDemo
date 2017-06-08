
//
//  SampleDownloadItem.m
//  DownloaderManager
//
//  Created by Ossey on 2017/6/5.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "SampleDownloadItem.h"

@interface SampleDownloadItem() <NSCoding>

@property (nonatomic, strong) NSString *urlPath;

@end


@implementation SampleDownloadItem

- (instancetype)init {
    NSAssert(NO, @"use - initWithURL:sessionDownloadTask:");
    @throw nil;
}
+ (instancetype)new {
    NSAssert(NO, @"use - initWithURL:sessionDownloadTask:");
    @throw nil;
}

- (instancetype)initWithURL:(NSString *)urlPath
                  remoteURL:(NSURL *)aRemoteURL {
    self = [super init];
    if (self)
    {
        self.urlPath = urlPath;
        self.status = SampleDownloadStatusNotStarted;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.urlPath forKey:NSStringFromSelector(@selector(urlPath))];
    [aCoder encodeObject:@(self.status) forKey:NSStringFromSelector(@selector(status))];
    if (self.resumeData.length > 0) {
        [aCoder encodeObject:self.resumeData forKey:NSStringFromSelector(@selector(resumeData))];
    } if (self.progressObj) {
        [aCoder encodeObject:self.progressObj forKey:NSStringFromSelector(@selector(progressObj))];
    } if (self.downloadError) {
        [aCoder encodeObject:self.downloadError forKey:NSStringFromSelector(@selector(downloadError))];
    } if (self.downloadErrorMessagesStack){
        [aCoder encodeObject:self.downloadErrorMessagesStack forKey:NSStringFromSelector(@selector(downloadErrorMessagesStack))];
    }
    if (self.localFileURL) {
        [aCoder encodeObject:self.localFileURL forKey:NSStringFromSelector(@selector(localFileURL))];
    }
    [aCoder encodeObject:@(self.lastHttpStatusCode) forKey:NSStringFromSelector(@selector(lastHttpStatusCode))];
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        self.urlPath = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(urlPath))];
        self.status = [[aCoder decodeObjectForKey:NSStringFromSelector(@selector(status))] unsignedIntegerValue];
        self.resumeData = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(resumeData))];
        self.progressObj = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(progressObj))];
        self.downloadError = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(downloadError))];
        self.downloadErrorMessagesStack = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(downloadErrorMessagesStack))];
        self.lastHttpStatusCode = [[aCoder decodeObjectForKey:NSStringFromSelector(@selector(lastHttpStatusCode))] integerValue];
        self.localFileURL = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(localFileURL))];
    }
    return self;
}


- (NSURL *)localFileURL {
    // 处理下载完成后保存的本地路径，由于归档之前获取到的绝对路径，而沙盒路径发送改变时，根据绝对路径是找到文件的
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentDirectoryName = [documentPath lastPathComponent];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheDirectoryName = [cachesPath lastPathComponent];
    
    NSArray *pathComponents = [_localFileURL pathComponents];
    
    if ([pathComponents containsObject:documentDirectoryName]) {
        NSString *urlPath = _localFileURL.path;
        NSArray *subList = [urlPath componentsSeparatedByString:documentDirectoryName];
        NSString *relativePath = [subList lastObject];
        NSString *newPath = [documentPath stringByAppendingString:relativePath];
        _localFileURL = [NSURL fileURLWithPath:newPath];
    } else if ([pathComponents componentsJoinedByString:cacheDirectoryName]) {
        NSString *urlPath = _localFileURL.path;
        NSArray *subList = [urlPath componentsSeparatedByString:cacheDirectoryName];
        NSString *relativePath = [subList lastObject];
        NSString *newPath = [cachesPath stringByAppendingString:relativePath];
        _localFileURL = [NSURL fileURLWithPath:newPath];
    }
    return _localFileURL;
}

#pragma mark - Description


- (NSString *)description {
    NSMutableDictionary *descriptionDict = [NSMutableDictionary dictionary];
    [descriptionDict setObject:self.urlPath forKey:@"urlPath"];
    [descriptionDict setObject:@(self.status) forKey:@"status"];
    if (self.progressObj)
    {
        [descriptionDict setObject:self.progressObj forKey:@"progressObj"];
    }
    if (self.resumeData.length > 0)
    {
        [descriptionDict setObject:@"resumeData exit" forKey:@"resumeData"];
    }
    if (self.localFileURL) {
        [descriptionDict setObject:self.localFileURL forKey:@"localFileURL"];
    }
    
    NSString *description = [NSString stringWithFormat:@"%@", descriptionDict];
    
    return description;
}

@end

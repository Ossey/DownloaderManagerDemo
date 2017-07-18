//
//  OSDownloadItem.m
//  DownloaderManager
//
//  Created by Ossey on 2017/6/4.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "OSDownloadItem.h"

@interface OSDownloadItem ()

/** 开始下载时的时间 */
@property (nonatomic, strong) NSDate *downloadStartDate;
/** 预计文件的总大小字节数 */
@property (nonatomic, assign) int64_t expectedFileTotalSize;
/** 已下载文件的大小字节数 */
@property (nonatomic, assign) int64_t receivedFileSize;
/** 恢复下载时所在文件的字节数 */
@property (nonatomic, assign) ino64_t resumedFileSizeInBytes;
/** 每秒下载的字节数 */
@property (nonatomic, assign) NSUInteger bytesPerSecondSpeed;
/** 下载进度 */
@property (nonatomic, strong) NSProgress *downloadProgress;
/** 下载的url */
@property (nonatomic, copy) NSString *urlPath;
/** 下载会话对象 NSURLSessionDownloadTask */
@property (nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;
/** 下载时发送的错误信息栈 */
@property (nonatomic, strong) NSArray<NSString *> *errorMessagesStack;
/** 最后的HTTP状态码 */
@property (nonatomic, assign) NSInteger lastHttpStatusCode;
/** 最终文件存储的本地路径 */
@property (nonatomic, strong) NSURL *finalLocalFileURL;
/** 文件的类型 */
@property (nonatomic, copy) NSString *MIMEType;

@end

@implementation OSDownloadItem

////////////////////////////////////////////////////////////////////////
#pragma mark - initialize
////////////////////////////////////////////////////////////////////////


- (instancetype)init {
    NSAssert(NO, @"use - initWithURL:sessionDownloadTask:");
    @throw nil;
}
+ (instancetype)new {
    NSAssert(NO, @"use - initWithURL:sessionDownloadTask:");
    @throw nil;
}

- (instancetype)initWithURL:(NSString *)urlPath sessionDownloadTask:(NSURLSessionDownloadTask *)sessionDownloadTask {
    if (self = [super init]) {
        self.urlPath = urlPath;
        self.sessionDownloadTask = sessionDownloadTask;
        self.receivedFileSize = 0;
        self.expectedFileTotalSize = 0;
        self.bytesPerSecondSpeed = 0;
        self.resumedFileSizeInBytes = 0;
        self.lastHttpStatusCode = 0;
        
        self.downloadProgress = [[NSProgress alloc] initWithParent:[NSProgress currentProgress] userInfo:nil];
        self.downloadProgress.kind = NSProgressKindFile;
        [self.downloadProgress setUserInfoObject:NSProgressFileOperationKindKey forKey:NSProgressFileOperationKindDownloading];
        [self.downloadProgress setUserInfoObject:urlPath forKey:@"urlPath"];
        self.downloadProgress.cancellable = YES;
        self.downloadProgress.pausable = YES;
        self.downloadProgress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        self.downloadProgress.completedUnitCount = 0;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Setter
////////////////////////////////////////////////////////////////////////


- (void)setExpectedFileTotalSize:(int64_t)expectedFileTotalSize {
    
    _expectedFileTotalSize = expectedFileTotalSize;
    if (expectedFileTotalSize > 0) {
        self.downloadProgress.totalUnitCount = expectedFileTotalSize;
    }
}

- (void)setReceivedFileSize:(int64_t)receivedFileSize {
    
    _receivedFileSize = receivedFileSize;
    if (receivedFileSize > 0) {
        if (self.expectedFileTotalSize > 0) {
            self.downloadProgress.completedUnitCount = receivedFileSize;
        }
    }
}


////////////////////////////////////////////////////////////////////////
#pragma mark - description
////////////////////////////////////////////////////////////////////////



- (NSString *)description {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(self.receivedFileSize) forKey:@"receivedFileSize"];
    [dict setObject:@(self.expectedFileTotalSize) forKey:@"expectedFileTotalSize"];
    [dict setObject:@(self.bytesPerSecondSpeed) forKey:@"bytesPerSecondSpeed"];
    [dict setObject:self.urlPath forKey:@"urlPath"];
    [dict setObject:self.downloadProgress forKey:@"naviteProgress"];
    if (self.sessionDownloadTask) {
        [dict setObject:@(YES) forKey:@"hasSessionDownloadTask"];
    }
    if (self.MIMEType) {
        [dict setObject:self.MIMEType forKey:@"MIMEType"];
    }
    NSString *description = [NSString stringWithFormat:@"%@", dict];
    
    return description;
}

@end

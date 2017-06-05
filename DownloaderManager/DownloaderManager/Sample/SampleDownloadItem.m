
//
//  SampleDownloadItem.m
//  DownloaderManager
//
//  Created by Ossey on 2017/6/5.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "SampleDownloadItem.h"

@interface SampleDownloadItem() <NSCoding>

@property (nonatomic, strong, readwrite, nonnull) NSString *downloadIdentifier;
@property (nonatomic, strong, readwrite, nonnull) NSURL *remoteURL;
@end


@implementation SampleDownloadItem


- (instancetype)initWithDownloadIdentifier:(NSString *)aDownloadIdentifier
                                 remoteURL:(NSURL *)aRemoteURL {
    self = [super init];
    if (self)
    {
        self.downloadIdentifier = aDownloadIdentifier;
        self.remoteURL = aRemoteURL;
        self.status = SampleDownloadItemStatusNotStarted;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.downloadIdentifier forKey:NSStringFromSelector(@selector(downloadIdentifier))];
    [aCoder encodeObject:self.remoteURL forKey:NSStringFromSelector(@selector(remoteURL))];
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
    [aCoder encodeObject:@(self.lastHttpStatusCode) forKey:NSStringFromSelector(@selector(lastHttpStatusCode))];
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        self.downloadIdentifier = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(downloadIdentifier))];
        self.remoteURL = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(remoteURL))];
        self.status = [[aCoder decodeObjectForKey:NSStringFromSelector(@selector(status))] unsignedIntegerValue];
        self.resumeData = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(resumeData))];
        self.progressObj = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(progressObj))];
        self.downloadError = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(downloadError))];
        self.downloadErrorMessagesStack = [aCoder decodeObjectForKey:NSStringFromSelector(@selector(downloadErrorMessagesStack))];
        self.lastHttpStatusCode = [[aCoder decodeObjectForKey:NSStringFromSelector(@selector(lastHttpStatusCode))] integerValue];
    }
    return self;
}


#pragma mark - Description


- (NSString *)description {
    NSMutableDictionary *aDescriptionDict = [NSMutableDictionary dictionary];
    [aDescriptionDict setObject:self.downloadIdentifier forKey:@"downloadIdentifier"];
    [aDescriptionDict setObject:self.remoteURL forKey:@"remoteURL"];
    [aDescriptionDict setObject:@(self.status) forKey:@"status"];
    if (self.progressObj)
    {
        [aDescriptionDict setObject:self.progressObj forKey:@"progressObj"];
    }
    if (self.resumeData.length > 0)
    {
        [aDescriptionDict setObject:@"hasData" forKey:@"resumeData"];
    }
    
    NSString *aDescriptionString = [NSString stringWithFormat:@"%@", aDescriptionDict];
    
    return aDescriptionString;
}

@end
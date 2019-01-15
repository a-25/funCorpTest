//
//  FetchService.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "FetchService.h"
#import "AFNetworking/AFNetworking.h"

@interface FetchService()

@property(nonatomic, strong) RLMRealm *realm;

@end

@implementation FetchService

-(id)init
{
    @throw nil;
}

- (instancetype)initWithDatabaseService:(DatabaseService*)databaseService andWaterfallItemListService:(WaterfallItemListService*)itemListService
{
    if (self = [super init]){
        _databaseService = databaseService;
        _waterfallItemListService = itemListService;
        _realm = [databaseService getRealm];
        _itemList = [itemListService list:_realm];
    }
    return self;
}

-(BOOL)isDataFetchedForItem:(WaterfallItemObject*)item
{
    //Assume that path does not change since the entity exists (otherwise it would be the other imageUrl)
    return item.cachedPath != nil;
}

-(void)fetchAsync:(WaterfallItemObject*)item completion:(nullable void (^)(WaterfallItemObject *item))completion
{
    if(completion) {
        completion(item);
    }
//    if([self isDataFetchedForItem:item]) {
//        return;
//    }
    
//    __weak FetchService *weakSelf = self;
//    RLMThreadSafeReference *itemRef = [RLMThreadSafeReference referenceWithThreadConfined:item];
//    [weakSelf download:item.imageUrl completion:^(NSString *localPath) {
//        dispatch_async(dispatch_queue_create("background", 0), ^{
//            @autoreleasepool {
//                RLMRealm *realm = [weakSelf.databaseService getRealm];
//                WaterfallItemObject *itemInTransaction = [realm resolveThreadSafeReference:itemRef];
//                if(localPath){
//                    [realm beginWriteTransaction];
//                    itemInTransaction.cachedPath = localPath;
//                    [realm addObject:itemInTransaction];
//                    [realm commitWriteTransaction];
//                }
//                RLMThreadSafeReference *itemRefInTransaction = [RLMThreadSafeReference referenceWithThreadConfined:itemInTransaction];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RLMRealm *realmInMain = [weakSelf.databaseService getRealm];
//                    if(completion) {
//                        completion([realmInMain resolveThreadSafeReference:itemRefInTransaction]);
//                    }
//                });
//            }
//        });
//    }];
}

-(void)download:(NSString*)url completion:(nullable void (^)(NSString *localPath))completion
{
    //Assume that the image is rather light - decided not to add queues or priorities
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(filePath) {
            if(completion) {
                completion(filePath.path);
            }
        } else {
            NSLog(@"File download error: %@", error.localizedDescription);
        }
    }];
    [downloadTask resume];
}

@end

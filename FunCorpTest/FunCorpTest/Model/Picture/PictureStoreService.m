//
//  PictureStoreService.m
//  FunCorpTest
//
//  Created by A-25 on 15/01/2019.
//  Copyright © 2019 rentateam. All rights reserved.
//

#import "PictureStoreService.h"
#import "AFNetworking/AFNetworking.h"
#import "Realm/Realm.h"
#import "WaterfallItemObject.h"
#import "PictureObject.h"

@interface PictureStoreService()

@property (nonatomic, strong, nullable) NSString *currentlyProcessingUrl;

@end

@implementation PictureStoreService

-(void)importFromApi:(unsigned long)page andPerPage:(unsigned long)perPage
{
    NSString *urlStr = [NSString stringWithFormat:@"https://pixabay.com/api/?key=%@&q=%@&image_type=photo&page=%ld&per_page=%ld",
                        self.apiKey,
                        self.query,
                        page + 1,
                        perPage];
    if([self.currentlyProcessingUrl isEqualToString:urlStr]) {
        NSLog(@"Request with url %@ is duplicate",urlStr);
        return;
    }
    self.currentlyProcessingUrl = urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak PictureStoreService *weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentlyProcessingUrl = nil;
            });
        } else {
            NSLog(@"%@ %@", response, responseObject);
            [self saveToDb:responseObject];
        }
    }];
    [dataTask resume];
}

-(void)saveToDb:(id)responseObject
{
    __weak PictureStoreService *weakSelf = self;
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [weakSelf.databaseService getRealm];
            __block long sortOrder = [WaterfallItemObject allObjectsInRealm:realm].count + 1;
            NSArray *pictureList = responseObject[@"hits"];
            [realm beginWriteTransaction];
            [pictureList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PictureObject *item = [weakSelf createPictureObject:obj withRealm: realm];
                [realm addObject:item];
                [weakSelf.waterfallItemCreateService createWithPicture:item inRealm:realm withSortOrder:sortOrder];
                sortOrder++;
            }];
            [realm commitWriteTransaction];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.currentlyProcessingUrl = nil;
            });
        }
    });
}

-(PictureObject*)createPictureObject:(id)item withRealm:(RLMRealm*)realm
{
    NSString *url = item[@"webformatURL"];
    PictureObject *obj = [PictureObject objectInRealm:realm forPrimaryKey:url];
    if(obj == nil) {
        obj = [[PictureObject alloc] init];
        obj.imageUrl = url;
    }
    obj.title = item[@"tags"];
    obj.views = [(NSNumber*)item[@"views"] intValue];
    obj.pageUrl = item[@"pageURL"];
    obj.webformatWidth = [(NSNumber*)item[@"webformatWidth"] intValue];
    obj.webformatHeight = [(NSNumber*)item[@"webformatHeight"] intValue];
    return obj;
}

@end

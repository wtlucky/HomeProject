//
//  HPHomeViewModel.m
//  HomeProject
//
//  Created by xushuai on 10/5/15.
//
//

#import "HPHomeViewModel.h"
#import "HPPhoto.h"

static const NSInteger requestPerpage = 20;

@interface HPHomeViewModel ()

@property (nonatomic, strong) NSURLSession *imageRequestSession;
@property (nonatomic, weak) NSURLSessionDataTask *runningTask;
@property (nonatomic, strong) NSMutableArray<HPPhoto *> *originPhotos;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, copy) NSArray<HPPhoto *> *images;

- (NSArray<HPPhoto *> *)sortOriginPhotos:(NSArray<HPPhoto *> *)originPhotos;
- (void)requestImageDatasWithSuccessHandler:(void (^)(void))success;

@end

@implementation HPHomeViewModel

- (NSURLSession *)imageRequestSession {
    if (!_imageRequestSession) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        configuration.timeoutIntervalForRequest = 15.0f;
        _imageRequestSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _imageRequestSession;
}

- (NSMutableArray *)originPhotos {
    if (!_originPhotos) {
        _originPhotos = [[NSMutableArray alloc] init];
    }
    return _originPhotos;
}

- (void)requestFirstPageImageDatasWithSuccessHandler:(void (^)(void))success {
    if (self.runningTask) {
        [self.runningTask cancel];
    }
    self.pageNumber = 1;
    [self requestImageDatasWithSuccessHandler:success];
}

- (void)requestNextPageImageDatasWithSuccessHandler:(void (^)(void))success {
    [self requestImageDatasWithSuccessHandler:success];
}

#pragma mark - Private Methods

- (void)requestImageDatasWithSuccessHandler:(void (^)(void))success {
    self.runningTask = [self.imageRequestSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=4037ab7e2bae4a015f9d67ef6c68a47e&per_page=%@&page=%@&format=json&extras=url_m&nojsoncallback=1", @(requestPerpage).stringValue, @(self.pageNumber).stringValue]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"request imageData error. error = %@", error.localizedDescription);
        } else {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray<NSDictionary *> *photoDatas = [[jsonData objectForKey:@"photos"] objectForKey:@"photo"];
            if (self.pageNumber == 1) {
                [self.originPhotos removeAllObjects];
            }
            self.pageNumber ++;
            [photoDatas enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.originPhotos addObject:[[HPPhoto alloc] initWithDictionary:obj]];
            }];
            self.images = [self sortOriginPhotos:self.originPhotos];
            dispatch_async(dispatch_get_main_queue(), ^{
                !success ?: success();
            });
        }
    }];
    [self.runningTask resume];
}

- (NSArray<HPPhoto *> *)sortOriginPhotos:(NSArray<HPPhoto *> *)originPhotos {
    NSMutableArray<HPPhoto *> *sortedPhotos = [[NSMutableArray alloc] initWithCapacity:originPhotos.count];
    int curPosition = 0, i = 0;
    while (i < originPhotos.count) {
        HPPhoto *photo = originPhotos[i];
        if(photo.isPortrait) {
            [sortedPhotos addObject:photo];
            curPosition = i;
            while (++i < originPhotos.count && !originPhotos[i].isPortrait) {}
            if (i < originPhotos.count) {
                [sortedPhotos addObject:originPhotos[i]];
                for (int k = curPosition + 1; k < i; k++) {
                    [sortedPhotos addObject:originPhotos[k]];
                }
            } else {
                [sortedPhotos addObject:[HPPhoto new]];
            }
        } else {
            [sortedPhotos addObject:photo];
        }
        i++;
    }
    return sortedPhotos.copy;
}

@end

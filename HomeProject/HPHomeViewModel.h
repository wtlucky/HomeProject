//
//  HPHomeViewModel.h
//  HomeProject
//
//  Created by xushuai on 10/5/15.
//
//

#import <Foundation/Foundation.h>

@class HPPhoto;

@interface HPHomeViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<HPPhoto *> *images;

- (void)requestFirstPageImageDatasWithSuccessHandler:(void (^)(void))success;
- (void)requestNextPageImageDatasWithSuccessHandler:(void (^)(void))success;

@end

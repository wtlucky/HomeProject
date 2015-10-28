//
//  HPPhoto.h
//  HomeProject
//
//  Created by xushuai on 10/5/15.
//
//

#import <Foundation/Foundation.h>

@interface HPPhoto : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url_m;
@property (nonatomic, strong) NSString *height_m;
@property (nonatomic, strong) NSString *width_m;
@property (nonatomic, assign) NSInteger farm;
@property (nonatomic, assign) NSInteger ispublic;
@property (nonatomic, assign) NSInteger isfriend;
@property (nonatomic, assign) NSInteger isfamily;

@property (nonatomic, assign, readonly, getter=isPortrait) BOOL portrait;

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary;

@end

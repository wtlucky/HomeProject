//
//  HPPhoto.m
//  HomeProject
//
//  Created by xushuai on 10/5/15.
//
//

#import "HPPhoto.h"

@implementation HPPhoto

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary {
    if (self = [super init]) {
        [super setValuesForKeysWithDictionary:dataDictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.photoID = value;
    }
}

- (BOOL)isPortrait {
    return self.height_m > self.width_m;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Photo: id = %@\n owner = %@\n secret = %@\n server = %@\n title = %@\n", self.photoID, self.owner, self.secret, self.server, self.title];
}

@end

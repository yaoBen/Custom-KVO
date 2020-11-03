//
//  XQPerson.m
//  Custom-KVO
//
//  Created by pinba on 2020/11/2.
//  Copyright © 2020 pinba. All rights reserved.
//

#import "XQPerson.h"

@implementation XQPerson

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"name"]) {
        return NO;
    }else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

- (void)setName:(NSString *)name
{
    if (name != _name) {
        [self willChangeValueForKey:@"name"];
        _name = name;
        [self didChangeValueForKey:@"name"];
    }
}
//- (NSString *)fullName {
//    return [NSString stringWithFormat:@"%@ %@",firstName, lastName];
//}
//
//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
// 
//    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
// 
//    if ([key isEqualToString:@"fullName"]) {
//        NSArray *affectingKeys = @[@"lastName", @"firstName"];
//        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
//    }
//    return keyPaths;
//}
//
//
//+ (NSSet *)keyPathsForValuesAffectingFullName {
//    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
//}
@end

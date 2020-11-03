//
//  PushViewController.m
//  Custom-KVO
//
//  Created by pinba on 2020/11/2.
//  Copyright © 2020 pinba. All rights reserved.
//

#import "PushViewController.h"
#import "XQPerson.h"
#import "NSObject+KVO.h"
@interface PushViewController ()
@property (nonatomic, strong) XQPerson *person;

@end
static void *PersonNameContext = &PersonNameContext;
static void *PersonNickNameContext = &PersonNickNameContext;
@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [XQPerson new];
        
//    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:PersonNameContext];
//    [self.person addObserver:self forKeyPath:@"nickName" options:NSKeyValueObservingOptionNew context:PersonNickNameContext];
    
    [self.person xq_addObserver:self forKeyPath:@"name" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"--%@--%@--%@--%@",observer,keyPath,oldValue,newValue);
    }];
    
    [self.person xq_addObserver:self forKeyPath:@"nickName" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"--%@--%@--%@--%@",observer,keyPath,oldValue,newValue);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person.name = @"113";
    self.person.nickName = @"xq_113";
//    [[self.person mutableArrayValueForKeyPath:@"mArray"] addObject:@"111"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"change:%@",change);
}

- (void)dealloc
{
//    [self.person removeObserver:self forKeyPath:@"name"];
//    [self.person removeObserver:self forKeyPath:@"nickName"];
    [self.person xq_removeObserver:self forKeyPath:@"name"];
    [self.person xq_removeObserver:self forKeyPath:@"nickName"];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
 
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
 
    if ([key isEqualToString:@"fullName"]) {
        NSArray *affectingKeys = @[@"lastName", @"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}


+ (NSSet *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}
@end

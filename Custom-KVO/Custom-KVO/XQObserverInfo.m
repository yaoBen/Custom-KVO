//
//  XQObserverInfo.m
//  Custom-KVO
//
//  Created by pinba on 2020/11/3.
//  Copyright © 2020 pinba. All rights reserved.
//

#import "XQObserverInfo.h"

@implementation XQObserverInfo
- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(XQKVOBlock)block{
    if (self=[super init]) {
        _observer = observer;
        _keyPath  = keyPath;
        _handleBlock = block;
    }
    return self;
}
@end

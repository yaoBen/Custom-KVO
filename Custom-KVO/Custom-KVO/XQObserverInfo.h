//
//  XQObserverInfo.h
//  Custom-KVO
//
//  Created by pinba on 2020/11/3.
//  Copyright © 2020 pinba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^XQKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);
@interface XQObserverInfo : NSObject
@property (nonatomic, weak) NSObject  *observer;
@property (nonatomic, copy) NSString    *keyPath;
@property (nonatomic, copy) XQKVOBlock  handleBlock;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath handleBlock:(XQKVOBlock)block;
@end

NS_ASSUME_NONNULL_END

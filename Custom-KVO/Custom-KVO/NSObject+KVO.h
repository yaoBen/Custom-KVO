//
//  NSObject+KVO.h
//  Custom-KVO
//
//  Created by pinba on 2020/11/3.
//  Copyright © 2020 pinba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQObserverInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)
- (void)xq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(XQKVOBlock)block;
- (void)xq_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
@end

NS_ASSUME_NONNULL_END

//
//  XQPerson.h
//  Custom-KVO
//
//  Created by pinba on 2020/11/2.
//  Copyright © 2020 pinba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQPerson : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSMutableArray *mArray;
@end

NS_ASSUME_NONNULL_END

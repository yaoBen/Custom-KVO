//
//  NSObject+KVO.m
//  Custom-KVO
//
//  Created by pinba on 2020/11/3.
//  Copyright © 2020 pinba. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

static NSString *const kXQKVOPrefix = @"XQKVONotifying_";
static NSString *const kXQKVOAssiociateKey = @"kXQKVO_AssiociateKey";


@implementation NSObject (KVO)
- (void)xq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(nonnull XQKVOBlock)block
{
    // 1,判断是否有setter方法
    [self judgmentSetterFuctionWithKey:keyPath];
    // 2: 动态生成子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    
    NSString *setterStr = setterForGetter(keyPath);
    SEL setterSEL = NSSelectorFromString(setterStr);
    Method m = class_getInstanceMethod([self class], setterSEL);
    class_addMethod(newClass, setterSEL, (IMP)xq_setter, method_getTypeEncoding(m));
    
    // 3: isa的指向 : LGKVONotifying_LGPerson
    object_setClass(self, newClass);
    
    // 4: 保存信息
    XQObserverInfo *info = [[XQObserverInfo alloc] initWitObserver:observer forKeyPath:keyPath handleBlock:block];
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXQKVOAssiociateKey));
    
    if (!mArray) {
        mArray = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kXQKVOAssiociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [mArray addObject:info];
    
}

- (void)xq_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXQKVOAssiociateKey));
    if (mArray.count <= 0) {
        return;
    }
    
    for (XQObserverInfo *info in mArray) {
        if ([info.keyPath isEqualToString:keyPath]) {
            [mArray removeObject:info];
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kXQKVOAssiociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    if (mArray.count <= 0) {
        Class superClass = [self class];
        object_setClass(self, superClass);
    }
    
}

- (void)judgmentSetterFuctionWithKey:(NSString *)keyPath
{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"没有当前%@的setter",keyPath] userInfo:nil];
    }
}
- (Class)createChildClassWithKeyPath:(NSString *)keyPath
{
    NSString *className = [NSString stringWithFormat:@"%@%@",kXQKVOPrefix,NSStringFromClass([self class])];
    Class newClass = NSClassFromString(className);
    if (newClass) {
        return newClass;
    }
    newClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    
    objc_registerClassPair(newClass);

    SEL classSEL = NSSelectorFromString(@"class");
    Method classM = class_getInstanceMethod([self class], classSEL);
    class_addMethod(newClass, classSEL, (IMP)xq_class, method_getTypeEncoding(classM));
    return newClass;
}

static void xq_setter(id self,SEL _cmd,id newValue)
{
    NSLog(@"来了:%@",newValue);
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keyPath];
    // 4: 消息转发 : 转发给父类
    // 改变父类的值 --- 可以强制类型转换
    void (*xq_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
    // void /* struct objc_super *super, SEL op, ... */
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    //objc_msgSendSuper(&superStruct,_cmd,newValue)
    xq_msgSendSuper(&superStruct,_cmd,newValue);
    
   // 5: 信息数据回调
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXQKVOAssiociateKey));
    
    for (XQObserverInfo *info in mArray) {
        if ([info.keyPath isEqualToString:keyPath] && info.handleBlock) {
            info.handleBlock(info.observer, keyPath, oldValue, newValue);
        }
    }
}

Class xq_class(id self,SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}
#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}
@end

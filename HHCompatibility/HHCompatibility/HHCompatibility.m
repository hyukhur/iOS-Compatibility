//
//  HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 12. 12. 29..
//  Copyright (c) 2012년 hyukhur. All rights reserved.
//

#import "HHCompatibility.h"
#import <dlfcn.h>
#import <string.h>
#import <objc/runtime.h>

#define HH_THREE_WAY_PASTER_INNER(a, b, c) a ## b ## c
#define HH_THREE_WAY_PASTER(x,y,z) HH_THREE_WAY_PASTER_INNER(x,y,z)


#define HH_SYNTHESIZE_ASSOCIATED_PROPERTY(aClassType, aSetter, aGetter, aAssociationPolicyType)\
HH_SYNTHESIZE_ASSOCIATED_PROPERTY__(aClassType, aSetter, aGetter, aAssociationPolicyType, HH_THREE_WAY_PASTER(kAssociatedObjectKeyFor_, aGetter, __LINE__))

#define HH_SYNTHESIZE_ASSOCIATED_PROPERTY__(aClassType, aSetter, aGetter, aAssociationPolicyType, aAssociatedObjectKey)\
static char aAssociatedObjectKey;                                                                                   \
- (void)aSetter:(aClassType)aAssociatedObject                                                                       \
{                                                                                                                   \
    if (![self.aGetter isEqual:aAssociatedObject])                                                                  \
    {                                                                                                               \
        if ([self respondsToSelector:@selector(aSetter##Will:)])                                                    \
        {                                                                                                           \
            [self performSelector:@selector(aSetter##Will:) withObject:aAssociatedObject];                          \
        }                                                                                                           \
        [self willChangeValueForKey:@"aGetter"];                                                                    \
        objc_setAssociatedObject(self, &aAssociatedObjectKey, aAssociatedObject, aAssociationPolicyType);           \
        [self didChangeValueForKey:@"aGetter"];                                                                     \
        if ([self respondsToSelector:@selector(aSetter##Did:)])                                                     \
        {                                                                                                           \
            [self performSelector:@selector(aSetter##Did:) withObject:aAssociatedObject];                           \
        }                                                                                                           \
    }                                                                                                               \
}                                                                                                                   \
- (aClassType)aGetter                                                                                               \
{                                                                                                                   \
    return objc_getAssociatedObject(self, &aAssociatedObjectKey);                                                   \
}                                                                                                                   \



static NSString *kMethodPrefix = @"hh_";
static NSString *kOriginMethodPrefix = @"hhOrigin_";

@implementation NSObject (HHCompatibility)


- (void)hh_forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sSelector = anInvocation.selector;
    if ([self respondsToSelector:sSelector])
    {
        [self hh_forwardInvocation:anInvocation];
        return;
    }
    NSString *sSelectorName = NSStringFromSelector(anInvocation.selector);
    if ([sSelectorName hasPrefix:kOriginMethodPrefix])
    {
        SEL sSelector = NSSelectorFromString([sSelectorName stringByReplacingOccurrencesOfString:kOriginMethodPrefix withString:@""]);
        if ([self respondsToSelector:sSelector])
        {
            [anInvocation setSelector:sSelector];
            [anInvocation invokeWithTarget:self];
            return;
        }
    }
    sSelector = NSSelectorFromString([kMethodPrefix stringByAppendingString:sSelectorName]);
    if ([self respondsToSelector:sSelector])
    {
        [anInvocation setSelector:sSelector];
        [anInvocation invokeWithTarget:self];
        return;
    }
    [self hh_forwardInvocation:anInvocation];
    return;
}


- (NSMethodSignature *)hh_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sSignature = nil;
    SEL sSelector = aSelector;
    sSignature = [self hh_methodSignatureForSelector:sSelector];
    if (sSignature)
    {
        return sSignature;
    }
    NSString *sSelectorName = NSStringFromSelector(sSelector);
    if ([sSelectorName hasPrefix:kOriginMethodPrefix])
    {
        sSelector = NSSelectorFromString([sSelectorName stringByReplacingOccurrencesOfString:kOriginMethodPrefix withString:@""]);
        sSignature = [self hh_methodSignatureForSelector:sSelector];
        if (sSignature)
        {
            return sSignature;
        }
    }
    sSelector = NSSelectorFromString([kMethodPrefix stringByAppendingString:sSelectorName]);
    sSignature = [self hh_methodSignatureForSelector:sSelector];
    if (sSignature)
    {
        return sSignature;
    }
    return [self hh_methodSignatureForSelector:aSelector];
}

@end


void HHMethodSwizzle(Class aClass, BOOL aIsInstance, SEL aOriginalSelector, SEL aAlternativedSelector)
{
    Class sClass = aIsInstance ? aClass : object_getClass(aClass);
    Method sOriginalMethod = class_getInstanceMethod(aClass, aOriginalSelector);
    Method sAlternativeMethod = class_getInstanceMethod(aClass, aAlternativedSelector);
    if (sClass != nil &&
        sOriginalMethod != nil &&
        sAlternativeMethod != nil &&
        strcmp(method_getTypeEncoding(sOriginalMethod), method_getTypeEncoding(sAlternativeMethod)) == 0)
    {
        class_addMethod(aClass, aOriginalSelector, class_getMethodImplementation(aClass, aOriginalSelector), method_getTypeEncoding(sOriginalMethod));
        class_addMethod(aClass, aAlternativedSelector, class_getMethodImplementation(aClass, aAlternativedSelector), method_getTypeEncoding(sAlternativeMethod));
        method_exchangeImplementations(class_getInstanceMethod(aClass, aOriginalSelector), class_getInstanceMethod(aClass, aAlternativedSelector));
    }
}


void HHMethodAdding(Class aClass, BOOL aIsInstance, SEL aOriginalSelector, SEL aAlternativedSelector)
{
    Class sClass = aIsInstance ? aClass : object_getClass(aClass);
    Method sAlternativeMethod = class_getInstanceMethod(aClass, aAlternativedSelector);
    if (sClass != nil &&
        sAlternativeMethod != nil)
    {
        class_addMethod(aClass, aOriginalSelector, class_getMethodImplementation(aClass, aAlternativedSelector), method_getTypeEncoding(sAlternativeMethod));
    }
}


@implementation HHCompatibility


- (BOOL)respondsToFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName
{
    void *(*function_handle)(void) = NULL;
    void *framework_handle = dlopen(aFrameworkName.UTF8String, RTLD_LAZY);
    if (framework_handle)
    {
        *(void **)&function_handle = dlsym(framework_handle, aFunctionName.UTF8String);
    }
    else
    {
        NSLog(@"Unable to open framework:%@ %s\n", aFrameworkName, dlerror());
    }
    dlclose(framework_handle);
    return function_handle != NULL;
}


- (id)performFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName
{
    void *(*function_handle)(void) = NULL;
    void *framework_handle = dlopen(aFrameworkName.UTF8String, RTLD_LAZY);
    if (framework_handle)
    {
        *(void **)&function_handle = dlsym(framework_handle, aFunctionName.UTF8String);
    }
    else
    {
        NSLog(@"Unable to open framework:%@ %s\n", aFrameworkName, dlerror());
    }
    dlclose(framework_handle);
    if (function_handle != NULL)
    {
        void *result = (*function_handle)();
        return [NSValue valueWithPointer:result];
    }
    return nil;
}



+ (void)initialize
{
    if ([NSObject instanceMethodForSelector:@selector(hh_methodSignatureForSelector:)] != [@"" methodForSelector:@selector(methodSignatureForSelector:)])
    {
        HHMethodSwizzle([NSObject class], NO, @selector(methodSignatureForSelector:), @selector(hh_methodSignatureForSelector:));
    }
    if ([NSObject instanceMethodForSelector:@selector(hh_forwardInvocation:)] != [@"" methodForSelector:@selector(forwardInvocation:)])
    {
        HHMethodSwizzle([NSObject class], NO, @selector(forwardInvocation:), @selector(hh_forwardInvocation:));
    }
}


@end

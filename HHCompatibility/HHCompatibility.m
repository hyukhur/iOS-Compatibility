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

#import "HHOrderedSet.h"


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



#define kMethodPrefix @"hh_"
#define kInitMethodPrefix @"initHH_"
#define kOriginInitMethodPrefix @"init"
#define kOriginMethodPrefix @"hhOrigin_"

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
    if ([sSelectorName hasPrefix:kOriginInitMethodPrefix])
    {
        sSelectorName = [sSelectorName stringByReplacingOccurrencesOfString:kOriginInitMethodPrefix withString:kInitMethodPrefix options:0 range:NSMakeRange(0, 4)];
    }
    else
    {
        sSelectorName = [kMethodPrefix stringByAppendingString:sSelectorName];
    }
    sSelector = NSSelectorFromString(sSelectorName);
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
    if ([sSelectorName hasPrefix:kOriginInitMethodPrefix])
    {
        sSelectorName = [sSelectorName stringByReplacingOccurrencesOfString:kOriginInitMethodPrefix withString:kInitMethodPrefix options:0 range:NSMakeRange(0, 3)];
    }
    else
    {
        sSelectorName = [kMethodPrefix stringByAppendingString:sSelectorName];
    }
    sSelector = NSSelectorFromString(sSelectorName);
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


void HHClassAdding(const char *aOriginalClassName, const char *aCompatibiltyClassName)
{
    if (!objc_getClass(aOriginalClassName))
    {
        Class sCompatibilityClass = objc_allocateClassPair(objc_getClass(aCompatibiltyClassName), aOriginalClassName, 0);
        objc_registerClassPair(sCompatibilityClass);
    }
}


@implementation HHCompatibility (HHPrivate)

- (NSString *)validFrameworkName:(NSString *)originalName
{
    NSString *frameworkName = originalName;
    if ([[frameworkName pathExtension] isEqualToString:@"framework"])
    {
        frameworkName = [frameworkName stringByAppendingPathComponent:[[[frameworkName pathComponents] lastObject] stringByReplacingOccurrencesOfString:@".framework" withString:@""]];
    }
    if (![frameworkName hasPrefix:@"/System/Library/Frameworks/"])
    {
        frameworkName = [NSString stringWithFormat:@"/System/Library/Frameworks/%@", frameworkName];
    }
    return frameworkName;
}

@end


@implementation HHCompatibility


- (BOOL)respondsToFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName
{
    NSString *sFrameworkName = [self validFrameworkName:aFrameworkName];
    void *(*function_handle)(void) = NULL;
    void *framework_handle = dlopen(sFrameworkName.UTF8String, RTLD_LAZY);
    if (framework_handle == NULL)
    {
        NSLog(@"Unable to open framework:%@ %s\n", aFrameworkName, dlerror());
        return NO;
    }
    *(void **)&function_handle = dlsym(framework_handle, aFunctionName.UTF8String);
    dlclose(framework_handle);
    return function_handle != NULL;
}


- (id)performFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName
{
    NSString *sFrameworkName = [self validFrameworkName:aFrameworkName];
    void *(*function_handle)(void) = NULL;
    void *framework_handle = dlopen(sFrameworkName.UTF8String, RTLD_LAZY);
    if (framework_handle == NULL)
    {
        NSLog(@"Unable to open framework:%@ %s\n", aFrameworkName, dlerror());
        return nil;
    }
    *(void **)&function_handle = dlsym(framework_handle, aFunctionName.UTF8String);
    dlclose(framework_handle);
    if (function_handle == NULL)
    {
        return nil;
    }
    void *result = (*function_handle)();
    return [NSValue valueWithPointer:result];
}


+ (void)load
{
    if ([NSObject instanceMethodForSelector:@selector(hh_methodSignatureForSelector:)] != [@"" methodForSelector:@selector(methodSignatureForSelector:)])
    {
        HHMethodSwizzle([NSObject class], NO, @selector(methodSignatureForSelector:), @selector(hh_methodSignatureForSelector:));
    }
    if ([NSObject instanceMethodForSelector:@selector(hh_forwardInvocation:)] != [@"" methodForSelector:@selector(forwardInvocation:)])
    {
        HHMethodSwizzle([NSObject class], NO, @selector(forwardInvocation:), @selector(hh_forwardInvocation:));
    }
    HHClassAdding("NSOrderedSet", "HHOrderedSet");
}


@end

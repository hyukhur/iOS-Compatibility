//
//  HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 12. 12. 29..
//  Copyright (c) 2012년 hyukhur. All rights reserved.
//

#import "HHCompatibility.h"
#import <dlfcn.h>


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


@end

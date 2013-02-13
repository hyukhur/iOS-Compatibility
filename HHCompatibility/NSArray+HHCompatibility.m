//
//  NSArray+HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 13. 2. 13..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import "NSArray+HHCompatibility.h"

@implementation NSArray (HHCompatibility_5_0)

- (NSUInteger)hh_indexOfObjectPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate
{
    __block NSUInteger result = NSNotFound;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if (predicate(obj, idx, stop))
         {
             result = idx;
         }
     }];
    return result;
}

@end

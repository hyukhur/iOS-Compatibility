//
//  NSArray+HHCompatibility.h
//  HHCompatibility
//
//  Created by hyukhur on 13. 2. 13..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HHCompatibility_5_0)
- (NSUInteger)hh_indexOfObjectPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate;
@end

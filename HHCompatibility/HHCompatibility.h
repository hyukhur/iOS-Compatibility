//
//  HHCompatibility.h
//  HHCompatibility
//
//  Created by hyukhur on 12. 12. 29..
//  Copyright (c) 2012년 hyukhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHCompatibility : NSObject
- (BOOL)respondsToFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName;
- (id)performFunction:(NSString *)aFunctionName inFramwork:(NSString *)aFrameworkName;
@end

#define HHClass(className) [className class] ? [className class] : NSClassFromString(@#className)

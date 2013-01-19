//
//  ALAssetRepresentation+HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 13. 1. 20..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import "ALAssetRepresentation+HHCompatibility.h"

@implementation ALAssetRepresentation (HHCompatibility)

- (NSString *)hh_filename __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_0);
{
    return self.url.pathComponents.lastObject;
}

- (CGSize)hh_dimensions __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_5_1);
{
    return CGSizeMake([self.metadata[@"PixelWidth"] floatValue], [self.metadata[@"PixelHeight"] floatValue]);
}

@end

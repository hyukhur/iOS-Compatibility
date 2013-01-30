//
//  UIImage+HHCompatibility.m
//  HHCompatibility
//
//  Created by hyukhur on 13. 1. 30..
//  Copyright (c) 2013년 hyukhur. All rights reserved.
//

#import "UIImage+HHCompatibility.h"

#define kUIImageEncodeKey @"UIImageData"

@implementation UIImage (HHCompatibility)

- (void)hh_encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:UIImagePNGRepresentation(self) forKey:kUIImageEncodeKey];
}


- (id)initHH_WithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self = [self initWithData:[aDecoder decodeObjectForKey:kUIImageEncodeKey]];
    }
    return self;
}

@end

//
//  HHCompatibilityTests.m
//  HHCompatibilityTests
//
//  Created by hyukhur on 12. 12. 29..
//  Copyright (c) 2012년 hyukhur. All rights reserved.
//

#import "HHCompatibilityTests.h"
#import "HHCompatibility.h"

@interface HHCompatibilityTests ()
- (BOOL)newAPIMethodButOldSDK;
- (BOOL)hhOrigin_newAPIMethod;
@end

@implementation HHCompatibilityTests


- (BOOL)newAPIMethod
{
    return YES;
}


- (BOOL)hh_newAPIMethodButOldSDK
{
    return NO;
}


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testPerformFunction
{
    HHCompatibility *instance = [[HHCompatibility alloc] init];
    STAssertTrue([instance respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework/AddressBook"], @"Function Load Fail");
    STAssertTrue([instance respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework"], @"Function Load Fail");
    STAssertTrue([instance respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"AddressBook.framework"], @"Function Load Fail");
    void *result = [[instance performFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework/AddressBook"] pointerValue];
    int resultValue = (int)result;
    STAssertEquals(resultValue, 3, @"");
}


- (void)testCompatibiltyMethodSwizzle
{
    __unused HHCompatibility *instance = [[HHCompatibility alloc] init];
    STAssertTrue([self newAPIMethod], @"");
    STAssertTrue([self hhOrigin_newAPIMethod], @"");
    STAssertFalse([self newAPIMethodButOldSDK], @"");
}

@end

//
//  HHCompatibilityTests.m
//  HHCompatibilityTests
//
//  Created by hyukhur on 12. 12. 29..
//  Copyright (c) 2012년 hyukhur. All rights reserved.
//


#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>

@interface HHCompatibilityTestsFixture : NSObject
@property (readonly) BOOL apiMethod;
@property (readonly) BOOL hhOrigin_oldAPIDeprecatedMethod;
@property (readonly) BOOL newAPIMethodButNotInOldSDK;
@end

@implementation HHCompatibilityTestsFixture
@dynamic hhOrigin_oldAPIDeprecatedMethod;
@dynamic newAPIMethodButNotInOldSDK;

- (BOOL)apiMethod
{
    return YES;
}

- (BOOL)oldAPIDeprecatedMethod
{
    return YES;
}

- (BOOL)hh_newAPIMethodButNotInOldSDK
{
    return YES;
}

@end


SPEC_BEGIN(HHCompatibilityCallSpec)
describe(@"HHCompatibility", ^{
    registerMatchers(@"BG");
    context(@"sometimes we would call the New API in an Old SDK", ^{
        __block id variable = nil;

        beforeAll(^{ // Occurs once
            variable = [[HHCompatibility alloc] init];
        });

        afterAll(^{ // Occurs once
        });

        beforeEach(^{ // Occurs before each enclosed "it"
        });

        afterEach(^{ // Occurs after each enclosed "it"
        });

        it(@"responds to the function with a framwork name", ^{
            [variable respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"AddressBook.framework"];
            [variable respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework"];
            [variable respondsToFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework/AddressBook"];
        });

        it(@"call the funtion", ^{
            void *result = [[variable performFunction:@"ABAddressBookGetAuthorizationStatus" inFramwork:@"/System/Library/Frameworks/AddressBook.framework/AddressBook"] pointerValue];
            int resultValue = (int)result;
            [[theValue(resultValue) should] equal:3 withDelta:0];
        });
    });
    context(@"we could call the New API in a New SDK, but it could not be called in an Old OS", ^{
        __unused HHCompatibility *compatibility = [[HHCompatibility alloc] init];
        __block id variable = nil;
        beforeAll(^{
            variable = [[HHCompatibilityTestsFixture alloc] init];
        });

        it(@"call the method in both old SDK and new SDK", ^{
            [[variable should] receive:@selector(apiMethod)];
            [[theValue([variable apiMethod]) should] beTrue];
        });

        it(@"call the method in old SDK but deprecated in new SDK", ^{
#warning TODO kiwi can not record method calling.
//            [[variable should] receive:@selector(oldAPIDeprecatedMethod)];
            [[theValue([variable hhOrigin_oldAPIDeprecatedMethod]) should] beTrue];
        });

        it(@"call the method in new SDK but not in old SDK", ^{
#warning TODO kiwi can not record method calling.
//            [[variable should] receive:@selector(hh_newAPIMethodButNotInOldSDK)];
            [[theValue([variable newAPIMethodButNotInOldSDK]) should] beTrue];
        });
    });
});
SPEC_END

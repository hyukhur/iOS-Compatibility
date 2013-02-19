#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>


SPEC_BEGIN(NSArraySpec)
describe(@"NSArray Compatibility Spec", ^{
    registerMatchers(@"BG");
    context(@"new API in SDK 5.0", ^{
        __block NSArray *variable = nil;

        beforeAll(^{
            variable = [NSArray arrayWithObjects:@"", @1, nil];
        });
        it(@"NSArray indexOfObjectPassingTest could be return passing test object index", ^{
            [[theValue([variable indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[NSNumber class]];
            }]) should] equal:1 withDelta:0];
        });
    });
});
SPEC_END

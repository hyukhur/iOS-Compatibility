#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>
#import <objc/runtime.h>

SPEC_BEGIN(NSOrderedSetSpec)
describe(@"NSOrderedSet Compatibility Spec", ^{
    registerMatchers(@"BG");
    context(@"new Object in SDK 5.0", ^{
        __block NSOrderedSet *variable = nil;
        __block NSString *firstObject;
        __block NSString *secondObject;
        __block NSString *thirdObject;
        beforeAll(^{
            firstObject = @"firstObject";
            secondObject = @"secondObject";
            thirdObject = @"thirdObject";
        });
        it(@"NSOrderedSet new method could be worked", ^{
            variable = [HHClass(NSOrderedSet) orderedSet];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithObject:firstObject];
            [variable shouldNotBeNil];
            NSString *objectArray[] = {firstObject, secondObject, thirdObject};
            variable = [HHClass(NSOrderedSet) orderedSetWithObjects:objectArray count:3];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [HHClass(NSOrderedSet) orderedSetWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
        });
        it(@"NSOrderedSet initialize method could be worked", ^{
            variable = [[HHClass(NSOrderedSet) alloc] initWithObject:firstObject];
            [variable shouldNotBeNil];
            NSString *objectArray[] = {firstObject, secondObject, thirdObject};
            variable = [[HHClass(NSOrderedSet) alloc] initWithObjects:objectArray count:3];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithObjects:firstObject, secondObject, thirdObject, nil];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithOrderedSet:[HHClass(NSOrderedSet) orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[HHClass(NSOrderedSet) alloc] initWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
        });
        it(@"NSOrderedSet has array's properties", ^{
            variable = [[HHClass(NSOrderedSet) alloc] initWithObject:firstObject];
            [[theValue([variable count]) should] equal:1 withDelta:0.f];

            variable = [[HHClass(NSOrderedSet) alloc] initWithObjects:firstObject, secondObject, thirdObject, nil];
            [[theValue([variable count]) should] equal:3 withDelta:0.f];
            [[theValue([variable indexOfObject:secondObject]) should] equal:1 withDelta:0];
            [[theValue([variable objectAtIndex:1]) should] equal:secondObject];
        });
    });
});
SPEC_END

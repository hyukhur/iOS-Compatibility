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
            variable = [objc_getClass(@"NSOrderedSet".UTF8String) orderedSet];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithObject:firstObject];
            [variable shouldNotBeNil];
            NSString *objectArray[] = {firstObject, secondObject, thirdObject};
            variable = [NSOrderedSet orderedSetWithObjects:objectArray count:3];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithArray:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithArray:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [NSOrderedSet orderedSetWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
        });
        it(@"NSOrderedSet initialize method could be worked", ^{
            variable = [[NSOrderedSet alloc] initWithObject:firstObject];
            [variable shouldNotBeNil];
            NSString *objectArray[] = {firstObject, secondObject, thirdObject};
            variable = [[NSOrderedSet alloc] initWithObjects:objectArray count:3];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithObjects:firstObject, secondObject, thirdObject, nil];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithOrderedSet:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithArray:[NSArray arrayWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithArray:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithArray:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:YES];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithArray:[NSOrderedSet orderedSetWithObjects:firstObject, secondObject, thirdObject, nil] range:NSMakeRange(1, 2) copyItems:NO];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil]];
            [variable shouldNotBeNil];
            variable = [[NSOrderedSet alloc] initWithSet:[NSSet setWithObjects:firstObject, secondObject, thirdObject, nil] copyItems:YES];
            [variable shouldNotBeNil];
        });
    });
});
SPEC_END

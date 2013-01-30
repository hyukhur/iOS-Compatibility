#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>
#import "UIImage+HHCompatibility.h"

SPEC_BEGIN(UIImageSpec)
describe(@"UIImage Compatibility Spec", ^{
    registerMatchers(@"BG");
    context(@"new API in SDK 5.0", ^{
        __block UIImage *variable = nil;
        __block NSString *fileName = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        beforeAll(^{
            NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"myGirl" ofType:@"JPG"];
            variable = [UIImage imageWithContentsOfFile:imagePath];
            NSString *folder = NSTemporaryDirectory();
            folder = [folder stringByExpandingTildeInPath];
            fileName = [folder stringByAppendingPathComponent:@"myGirl.tmp"];
        });
        it(@"UIImage can be archived in iOS 4.3", ^{
            [[theValue([NSKeyedArchiver archiveRootObject:variable toFile:fileName]) should] beTrue];
            [[theValue([fileManager fileExistsAtPath:fileName]) should] beTrue];
            UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            [[theValue(image) should] beNonNil];
            [[theValue(image.size) should] equal:theValue(variable.size)];

            [fileManager removeItemAtPath:fileName error:NULL];
        });
    });
});
SPEC_END

#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>
#import "UIViewController+HHCompatibility.h"


@implementation UIViewController (Test)

//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    [self forwardInvocation:[NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(presentViewController:animated:completion:)]]];
//}

@end


SPEC_BEGIN(UIViewControllerSpec)
describe(@"UIViewController Compatibility Spec", ^{
    registerMatchers(@"BG");
    context(@"new API in SDK 5.0", ^{
        __block UIViewController *variable = nil;
        beforeAll(^{
            variable = [UIViewController new];
        });
        it(@"", ^{
            [variable presentViewController:[UIViewController new] animated:NO completion:nil];
        });
    });
});
SPEC_END

#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>
#import "UIViewController+HHCompatibility.h"
#import <objc/runtime.h>


void removeMethod(id aInstance, SEL beRemovedMethodSelector)
{
    if ([aInstance respondsToSelector:beRemovedMethodSelector])
    {
        Class class = object_getClass(aInstance);
        Method beRemovdMethod = class_getInstanceMethod(class, beRemovedMethodSelector);
        IMP forwardingIMP = class_getMethodImplementation(class, @selector(forwardInvocation:));
        method_setImplementation(beRemovdMethod, forwardingIMP);
    }
}


SPEC_BEGIN(UIViewControllerSpec)
describe(@"UIViewController Compatibility Spec", ^{
    registerMatchers(@"BG");
    context(@"new API in SDK 5.0", ^{
        __block UIViewController *variable = nil;
        beforeAll(^{
            variable = [[UIViewController alloc] init];
            removeMethod(variable, @selector(presentViewController:animated:completion:));
        });
        it(@"", ^{
            [variable presentViewController:[UIViewController new] animated:NO completion:nil];
        });
    });
});
SPEC_END

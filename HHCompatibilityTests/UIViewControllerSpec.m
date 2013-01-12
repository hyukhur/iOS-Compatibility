#import "HHCompatibility.h"
#import <Kiwi/Kiwi.h>
#import "UIViewController+HHCompatibility.h"
#import <objc/runtime.h>

// class_getMethodImplementation()
//method_setImplementation(methodToRemove, forwardingIMP);

void removeMethod(id aInstance, SEL beRemovedMethodSelector)
{
    if ([aInstance respondsToSelector:beRemovedMethodSelector])
    {
        Method beRemovdMethod = class_getInstanceMethod(aInstance, beRemovedMethodSelector);
        IMP forwardingIMP = method_getImplementation(class_getInstanceMethod(aInstance, @selector(forwardInvocation:)));
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
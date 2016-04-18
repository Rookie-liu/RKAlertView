# RKAlertView
## AlertView.. 
___自动ios8废弃掉AlertView后, 心里很不舒服, 用AlertViewController心里感觉各种莫名不爽 , 然后自己重新搞了一个.___

____AlertView:人家明明很好用, 为什么要废弃恩 ___


用起来很简单
```
RKAlertView *va = [RKAlertView alertViewWithTitle:@"提示信息" message:@"我是一个AlertView" CanclebuttonTitle:@"取消" OKbuttonTitle:@"确定" buttonTouchedAction:^{
        NSLog(@"取消");
    } buttonCheckTouchedAction:^{
        NSLog(@"确定");
    } dismissAction:^{
        NSLog(@"消失");
    }];
    [va show];

```

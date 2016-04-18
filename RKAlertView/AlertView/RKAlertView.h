//
//  RKAlertView.h
//  AlertView
//
//  Created by Rookie on 16/4/18.
//  Copyright © 2016年 Rookie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RKAlertViewBlock)(void);


@interface RKAlertView : UIView

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 CanclebuttonTitle:(NSString *)buttonTitle
                     OKbuttonTitle:(NSString *)buttonTitle1
               buttonTouchedAction:(RKAlertViewBlock)buttonAction
          buttonCheckTouchedAction:(RKAlertViewBlock)buttonAction
                     dismissAction:(RKAlertViewBlock)dismissAction;

- (void)show;
- (void)dismiss;

@end

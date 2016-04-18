//
//  RKAlertView.m
//  AlertView
//
//  Created by Rookie on 16/4/18.
//  Copyright © 2016年 Rookie. All rights reserved.
//

#import "RKAlertView.h"

static const float finalAngle = 45;
static const float backgroundViewAlpha = 0.5;
static const float alertViewCornerRadius = 8;


@interface RKAlertView ()


// backgroundView, alertView
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;

// titleLabel, messageLable, button
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *button1;


// autolayout constraint for alertview centerY
@property (nonatomic) NSLayoutConstraint *alertConstraintCenterY;

// title, message, button text
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *messageText;
@property (nonatomic) NSString *buttonTitleText;
@property (nonatomic) NSString *buttonTitleText1;


// blocks
@property (nonatomic, copy) RKAlertViewBlock buttonBlock;
@property (nonatomic, copy) RKAlertViewBlock buttonCheckBlock;
@property (nonatomic, copy) RKAlertViewBlock dismissBlock;

@property (nonatomic) float rorateDirection;


@end


@implementation RKAlertView

#pragma mark - init

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                 CanclebuttonTitle:(NSString *)buttonTitle
                     OKbuttonTitle:(NSString *)buttonTitle1
               buttonTouchedAction:(RKAlertViewBlock)buttonAction
          buttonCheckTouchedAction:(RKAlertViewBlock)buttonAction1
                     dismissAction:(RKAlertViewBlock)dismissAction {
    return [[RKAlertView alloc] initWithTitle:title message:message CanclebuttonTitle:buttonTitle OKbuttonTitle:buttonTitle1 buttonTouchedAction:buttonAction buttonCheckTouchedAction:buttonAction1 dismissAction:dismissAction];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            CanclebuttonTitle:(NSString *)buttonTitle
                OKbuttonTitle:(NSString *)buttonTitle1
          buttonTouchedAction:(RKAlertViewBlock)buttonAction
     buttonCheckTouchedAction:(RKAlertViewBlock)buttonAction1
                dismissAction:(RKAlertViewBlock)dismissAction {
    self = [super init];
    if (self) {
        _buttonTitleText = buttonTitle;
        _buttonTitleText1 = buttonTitle1;
        _messageText = message;
        _titleText = title;
        
        _buttonBlock = buttonAction;
        _buttonCheckBlock = buttonAction1;
        _dismissBlock = dismissAction;
        
        [self setup];
    }
    return self;
}

#pragma mark - setups

- (void)setup {
    [self setupBackground];
    
    [self setupAlertView];
    
    [self setupTitleLabel];
    
    [self setupContent];
    
    [self setupButton];
    [self setupButton1];
    
    // setup KVO
    //    [self setupKVO];
    
    // setup layout constraints
    [self setupLayoutConstraints];
}

- (void)setupLayoutConstraints {
    CGFloat f = 270/2;
    NSNumber *number =[NSNumber numberWithFloat:f];
    // metrics and views
    NSDictionary *metrics = @{@"padding": @20,
                              @"pad":@0,
                              @"buttonHeight": @44,
                              @"buttonW":number,
                              };
    NSDictionary *views = @{@"title": _titleLabel,
                            @"content": _messageLabel,
                            @"button": _button,
                            @"button1": _button1,
                            };
    
    // vertical layout 垂直约束
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"V:|-padding-[title]-[content]-padding-[button(==buttonHeight)]|"
                                options:0
                                metrics:metrics
                                views:views]];
    
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"V:|-padding-[title]-[content]-padding-[button1(==buttonHeight)]|"
                                options:0
                                metrics:metrics
                                views:views]];
    
    // horizontal layout 水平约束
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-[title]-|"
                                options:0
                                metrics:metrics
                                views:views]];
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-[content]-|"
                                options:0
                                metrics:metrics
                                views:views]];
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|[button(==buttonW)]|"
                                options:0
                                metrics:metrics
                                views:views]];
    [_alertView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-[content]-pad-[button1(==buttonW)]|"
                                options:0
                                metrics:metrics
                                views:views]];
}

- (void)setupBackground {
    UIView *v = [UIView new];
    v.translatesAutoresizingMaskIntoConstraints = NO;
    v.backgroundColor = [UIColor blackColor];
    
    [self addSubview:v];
    
    [self addSizeFitConstraint:v toView:self widthConstant:0 heightConstant:0];
    
    _backgroundView = v;
}


- (void)setupAlertView {
    // init
    _alertView = [UIView new];
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    _alertView.layer.cornerRadius = alertViewCornerRadius;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    
    // add pan gesture
    //    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    panGesture.minimumNumberOfTouches = 1;
    //    panGesture.maximumNumberOfTouches = 1;
    //    [_alertView addGestureRecognizer:panGesture];
    
    // autolayout constraint
    NSLayoutConstraint *constraintCenterX =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *constraintCenterY =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    self.alertConstraintCenterY = constraintCenterY;
    
    NSLayoutConstraint *constraintWidth =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:270];
    
    NSLayoutConstraint *constraintHeightMin =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:130];
    
    NSLayoutConstraint *constraintHeightMax =
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:-50];
    [self addConstraints:@[constraintCenterX, constraintCenterY, constraintWidth, constraintHeightMin, constraintHeightMax]];
}

- (void)setupTitleLabel {
    UILabel *label = [self labelWithText:_titleText];
    label.font = [UIFont boldSystemFontOfSize:17];
    [_alertView addSubview:label];
    _titleLabel = label;
}

- (void)setupContent {
    UILabel *label = [self labelWithText:_messageText];
    label.font = [UIFont systemFontOfSize:14];
    [_alertView addSubview:label];
    _messageLabel = label;
}

- (void)setupButton {
    // init
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.shadowColor = [[UIColor grayColor] CGColor];
    _button.layer.shadowRadius = 0.5;
    _button.layer.shadowOpacity = 1;
    _button.layer.shadowOffset = CGSizeZero;
    _button.layer.masksToBounds = NO;
    
    // background color
    [_button setBackgroundImage:imageFromColor([UIColor grayColor])
                       forState:UIControlStateHighlighted];
    [_button setBackgroundImage:imageFromColor([UIColor whiteColor])
                       forState:UIControlStateNormal];
    
    // title
    [_button setTitle:_buttonTitleText forState:UIControlStateNormal];
    [_button setTitle:_buttonTitleText forState:UIControlStateSelected];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:_button.titleLabel.font.pointSize];
    
    // action
    [_button addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:_button];
}

- (void)setupButton1 {
    // init
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.translatesAutoresizingMaskIntoConstraints = NO;
    
    // gray seperator
    _button1.backgroundColor = [UIColor whiteColor];
    _button1.layer.shadowColor = [[UIColor grayColor] CGColor];
    _button1.layer.shadowRadius = 0.5;
    _button1.layer.shadowOpacity = 1;
    _button1.layer.shadowOffset = CGSizeZero;
    _button1.layer.masksToBounds = NO;
    
    // background color
    [_button1 setBackgroundImage:imageFromColor([UIColor grayColor])
                        forState:UIControlStateHighlighted];
    [_button1 setBackgroundImage:imageFromColor([UIColor whiteColor])
                        forState:UIControlStateNormal];
    
    // title
    [_button1 setTitle:_buttonTitleText1 forState:UIControlStateNormal];
    [_button1 setTitle:_buttonTitleText1 forState:UIControlStateSelected];
    _button1.titleLabel.font = [UIFont boldSystemFontOfSize:_button.titleLabel.font.pointSize];
    
    // action
    [_button1 addTarget:self
                 action:@selector(buttonCheckAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:_button1];
}

#pragma mark - gesture recognizer

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    UIView *v = recognizer.view;
    CGPoint translation = [recognizer translationInView:v];
    [recognizer setTranslation:CGPointZero inView:v];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint position =  [recognizer locationInView:v];
        self.rorateDirection = position.x > CGRectGetMidX(v.bounds) ? 1 : -1;
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        // update alertview constraint
        self.alertConstraintCenterY.constant += translation.y;
        
        // rotate
        float halfScreenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        float ratio = self.alertConstraintCenterY.constant / halfScreenHeight;
        // change background alpha when slide down
        if (ratio > 0) {
            _backgroundView.alpha = backgroundViewAlpha - ratio * backgroundViewAlpha;
        }
        
        CGFloat finalDegree = 45;
        CGFloat radian = finalDegree * (M_PI / 180) * ratio * self.rorateDirection;
        v.transform = CGAffineTransformMakeRotation(radian);
    } else {
        [self panEnd];
    }
}

- (void)panEnd {
    if (fabs(self.alertView.center.y - self.bounds.size.height) < (self.bounds.size.height / 4)) {
        [self dismiss];
    } else {
        [self resetAlertViewPosition];
    }
}

#pragma mark - show and dismiss

- (void)show {
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = w.subviews[0];
    
    // NOTE, hack for iOS7.
    // only keyWindow.subviews[0] get rotation event in iOS7
    [topView addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSizeFitConstraint:self toView:topView widthConstant:0 heightConstant:0];
    
    [self showAlertView];
}

- (void)showAlertView {
    // init state
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat y = -(CGRectGetHeight(screenBounds) + CGRectGetHeight(_alertView.frame)/2);
    
    _backgroundView.alpha = backgroundViewAlpha;
    _alertView.center = CGPointMake(_alertView.center.x, y);
    _alertView.transform = CGAffineTransformMakeRotation(finalAngle);
    
    
    _backgroundView.alpha = backgroundViewAlpha;
    _alertView.transform = CGAffineTransformMakeRotation(0);
    _alertView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                    CGRectGetMidY(self.bounds));
    
}

- (void)dismiss {
    
    _backgroundView.alpha = 0.0;
    
    _alertView.transform = CGAffineTransformMakeRotation(finalAngle);
    _alertView.alpha = 0.0;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float finalY = screenBounds.size.height / 2 + self.alertView.bounds.size.height;
    self.alertConstraintCenterY.constant += finalY;
    
    [self layoutIfNeeded];
    [self removeFromSuperview];
    if (_dismissBlock != NULL) {
        _dismissBlock();
    }
}

- (void)resetAlertViewPosition {
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.alpha = backgroundViewAlpha;
                         _alertView.transform = CGAffineTransformMakeRotation(0);
                         self.alertConstraintCenterY.constant = 0;
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

#pragma mark - button action

/**
 *  忽略按钮
 *
 *  @param sender sender
 */
- (void)buttonAction:(UIButton *)sender {
    if (_buttonBlock != NULL) {
        _buttonBlock();
    }
    [self dismiss];
}

- (void)buttonCheckAction:(UIButton *)sender {
    if (_buttonCheckBlock != NULL) {
        _buttonCheckBlock();
    }
    [self dismiss];
}



#pragma mark - helper methods

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    return label;
}

- (void)addSizeFitConstraint:(id)view1
                      toView:(id)view2
               widthConstant:(CGFloat)widthConstant
              heightConstant:(CGFloat)heightConstant {
    NSLayoutConstraint *centerX =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *centerY =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint *width =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.1     // NOTE, hack to work with ios7
                                  constant:widthConstant];
    
    NSLayoutConstraint *height =
    [NSLayoutConstraint constraintWithItem:view1
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view2
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.1     // NOTE, hack to work with ios7
                                  constant:heightConstant];
    
    [view2 addConstraints:@[centerX, centerY, width, height]];
}

UIImage *
imageFromColor(UIColor *color){
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end


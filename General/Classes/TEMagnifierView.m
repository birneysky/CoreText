//
//  TEMagnifierView.m
//  CoreText
//
//  Created by zhangguang on 16/11/29.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TEMagnifierView.h"



@implementation TEMagnifierView


- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 110, 110)]) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = [self width] / 2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 100);
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width * 0.5,self.frame.size.height * 0.5);
    CGContextScaleCTM(context, 1.2, 1.2);
    CGContextTranslateCTM(context, -1 * (_touchPoint.x), -1 * (_touchPoint.y));
    [self.magnifiedTagetView.layer renderInContext:context];
}


@end

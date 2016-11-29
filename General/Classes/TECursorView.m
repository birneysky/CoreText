//
//  TECursorView.m
//  CoreText
//
//  Created by zhangguang on 16/11/28.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TECursorView.h"

@implementation TECursorView


- (instancetype)initWithFrame:(CGRect)frame style:(TECursorStyle)style
{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint circurlarCenter = CGPointZero;
    CGPoint lineStartPointer = CGPointZero;
    CGPoint lineEndPointer = CGPointZero;
    if (TECursorStyleStart == self.style) {
        lineStartPointer = CGPointMake(rect.size.width / 2, 4);
        lineEndPointer = CGPointMake(rect.size.width / 2, rect.size.height);
        circurlarCenter = lineStartPointer;
    }
    else{
        lineStartPointer = CGPointMake(rect.size.width / 2, 0);
        lineEndPointer = CGPointMake(rect.size.width / 2, rect.size.height - 4);
        circurlarCenter = lineEndPointer;
    }
    [self.color setStroke];
    UIBezierPath* linePath = [[UIBezierPath alloc] init];
    [linePath moveToPoint:lineStartPointer];
    [linePath addLineToPoint:lineEndPointer];
    linePath.lineWidth = 1.0f;
    [linePath stroke];
    
    [self.color setFill];
    UIBezierPath* circularPath = [[UIBezierPath alloc] init];
    [circularPath addArcWithCenter:circurlarCenter radius:4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [circularPath fill];
    
}


- (UIColor*)color
{
    if (_color) {
        return _color;
    }
    return [self defaultColor];
}


- (UIColor *)defaultColor; {
    return [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:1];
}


- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.origin = CGPointMake(position.x - self.width/ 2 , position.y - self.height);
    if (TECursorStyleEnd == self.style) {
        self.y += 2;
    }
    [self setNeedsDisplay];
}

@end

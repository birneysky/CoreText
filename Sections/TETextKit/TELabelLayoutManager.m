//
//  TELabelLayoutManager.m
//  CoreText
//
//  Created by zhangguang on 16/11/25.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TELabelLayoutManager.h"

@implementation TELabelLayoutManager


- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    //self.lastDrawPoint = origin;
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    //self.lastDrawPoint = CGPointZero;
}

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        [super fillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:color];
        return;
    }
    
     CGContextSaveGState(ctx);
    {
        for (NSInteger i=0; i<rectCount; i++) {
            CGRect validRect =  rectArray[i];
            if (!CGRectIsEmpty(validRect)) {
                CGContextFillRect(ctx, validRect);
            }
        }
    }
}

@end

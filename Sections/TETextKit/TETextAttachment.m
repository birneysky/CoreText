//
//  TETextAttachment.m
//  CoreText
//
//  Created by zhangguang on 16/11/25.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TETextAttachment.h"

@implementation TETextAttachment

- (CGRect) attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    if (self.image) {

        UIFont *font = [textContainer.layoutManager.textStorage attribute:NSFontAttributeName
                                                              atIndex:charIndex
                                                       effectiveRange:nil];
        CGFloat baseLineHeight = (font?font.lineHeight:lineFrag.size.height);

        CGFloat width = 0;
        CGFloat height = 0;
        width = height = baseLineHeight;
        CGFloat imageAspectRation = self.image.size.width / self.image.size.height;
        if (imageAspectRation > 0) {
            width = height * imageAspectRation;
        }else{
            if (width == 0&& height == 0) {
                width = height = lineFrag.size.height;
            }else if (width==0&&height!=0) {
                width = height;
            }else if (height==0&&width!=0) {
                height = width;
            }
        }

        CGFloat y = font.descender;
        y -= (height-baseLineHeight)/2;

        return CGRectMake(0, y, width, width);
    }

    
    return [super attachmentBoundsForTextContainer:textContainer proposedLineFragment:lineFrag glyphPosition:position characterIndex:charIndex];
}

@end

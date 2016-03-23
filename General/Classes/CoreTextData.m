//
//  CoreTextData.m
//  CoreText
//
//  Created by birneysky on 15/11/29.
//  Copyright © 2015年 birneysky. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

- (void)dealloc
{
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setCtFrame:(CTFrameRef)ctFrame
{
    if (_ctFrame != ctFrame) {
        if (_ctFrame ) {
            CFRelease(_ctFrame);
        }
        
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}


- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self fillImagePostion];
}


//用于找到每张图片在绘制时的位置
- (void)fillImagePostion
{
    if (0 == self.imageArray.count) {
        return;
    }
    
    NSArray* lines = (NSArray*)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    NSUInteger imgIndex = 0;
    
    CoreTextImageData* imageData = self.imageArray[0];
    
    for (int i = 0; i < lineCount; i++) {
        if (!imageData) {
            return;
        }
        
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        NSArray* runObjArray = (NSArray*)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)(runObj);
            NSDictionary* runAttributes = (NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes objectForKey:(id)kCTRunDelegateAttributeName]);
            if (!delegate) {
                continue;
            }
            
            NSDictionary* metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            
            CGFloat xoffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xoffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
            imgIndex ++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            }
            else{
                imageData = self.imageArray[imgIndex];
            }
        }
        
    }
}

@end

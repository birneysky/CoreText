//
//  CTDisplayView.m
//  CoreText
//
//  Created by birneysky on 15/11/28.
//  Copyright © 2015年 birneysky. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"


@interface CTDisplayView () <UIGestureRecognizerDelegate>

@end

@implementation CTDisplayView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupEvents];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 得到当前绘制画布的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建绘制区域
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
//    
//    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:@"Hello,无法可修饰的一对手，带出温暖永远背后，么么哒 么么哒 我来到你的城市走过你来时的路，想象你的画面，我回到那天，你回忆，为什么我受伤的总是我，我减肥了的撒到家啦房间里的撒娇疯了老对手将立法将阿里点击撒了福建代理商两地分居法拉盛解放路口的萨拉房价多少了尽量少打减肥了的撒浪费了的撒领导老大撒理发店里撒了到拉萨疯了打算理发拉萨了乐山大佛拉萨的了代理商拉屎老大撒楼房的萨拉LSD楼房的撒娇了房间里的撒减肥了的撒的萨拉附近的萨拉反倒是， 反倒是拉飞机的拉萨减肥了撒了法律的撒家里的事历史地理到拉萨放进来撒老大撒楼房的萨拉反对了撒法律的撒法律的撒了第三方拉萨路费的撒了法律的撒法律的撒了分手了是懒得飞拉萨飞拉萨路发生撒了到拉萨法律的撒法律的撒的快乐撒法律的撒了老大撒法律的撒飞机老大撒理发店里撒了"];
//    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
//    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, attributedString.length), path, NULL);
//    
//    CTFrameDraw(frameRef, context);
//    
//    CFRelease(path);
//    CFRelease(setterRef);
//    CFRelease(frameRef);

    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
        for (CoreTextImageData* imgData in self.data.imageArray) {
            CGContextDrawImage(context, imgData.imagePosition, [UIImage imageNamed:imgData.name].CGImage);
        }
        
    }
}


#pragma mark - *** Helper ***
- (void)setupEvents
{
    UIGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDeteched:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}


#pragma mark - *** Gesture Selector ***
- (void)userTapGestureDeteched:(UIGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    DebugLog(@"Tap Point %@",NSStringFromCGPoint(point));
    for (CoreTextImageData* imageData in self.data.imageArray) {
        //翻转坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePostion = imageRect.origin;
        
        imagePostion.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        
        CGRect rect = CGRectMake(imagePostion.x, imagePostion.y, imageRect.size.width, imageRect.size.height);
        
        if (CGRectContainsPoint(rect, point)) {
            DebugLog(@"picture rect = %@",NSStringFromCGRect(rect));
        }
        
    }
}

@end

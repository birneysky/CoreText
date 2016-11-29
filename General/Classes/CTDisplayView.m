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
#import "TECursorView.h"
#import "TEMagnifierView.h"

@interface CTDisplayView () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) TECursorView* startCursor;
@property (nonatomic,strong) TECursorView* endCursor;

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,assign) NSRange selectedTextRange;

@property (nonatomic,strong) TEMagnifierView* magnifierView;

@end

@implementation CTDisplayView

#pragma mark - *** Properties ***
- (TECursorView*)startCursor {
    if (!_startCursor) {
        _startCursor = [[TECursorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44) style:TECursorStyleStart];
    }
    return _startCursor;
}

- (TECursorView*)endCursor{
    if (!_endCursor) {
        _endCursor = [[TECursorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44) style:TECursorStyleEnd];
    }
    return _endCursor;
}


- (TEMagnifierView*)magnifierView
{
    if (!_magnifierView) {
        _magnifierView = [[TEMagnifierView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        _magnifierView.magnifiedTagetView = self;
    }
    return _magnifierView;
}

#pragma mark  *** Initializer ***
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
    
    
    NSArray<NSString*>* rects = [self selectRectsOfRange:self.selectedTextRange];
    [self drawBackgroundFromRects:rects];
    [self resetCursor:rects];
    //self.image =  self.layer.contents;
    
}


#pragma mark - *** Helper ***
- (void)setupEvents
{
    UIGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDeteched:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
    
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userPanGestureDeteched:)];
    //panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer* longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userLongGestureDeteched:)];
    [self addGestureRecognizer:longRecognizer];
}



/**
 重置光标的位置

 @param rectArray 选中的区域
 */
- (void)resetCursor:(NSArray<NSString*>*)rectArray{
    
    if (!rectArray || 0 == rectArray.count) {
        return;
    }
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    CGFloat leftHeight = CGRectFromString(rectArray.firstObject).size.height;
    CGPoint leftCursorPoint = CGRectFromString([rectArray objectAtIndex:0]).origin;
    leftCursorPoint = CGPointApplyAffineTransform(leftCursorPoint, transform);
    self.startCursor.height = leftHeight + 4;
    self.startCursor.width = leftHeight + 4;
    self.startCursor.position = leftCursorPoint;
    
    CGPoint rightCursorPoint = CGRectFromString([rectArray lastObject]).origin;
    CGFloat rightHeight = CGRectFromString(rectArray.lastObject).size.height;
    rightCursorPoint.x = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint = CGPointApplyAffineTransform(rightCursorPoint, transform);
    self.endCursor.height = rightHeight + 4;
    self.endCursor.width = rightHeight + 4;
    self.endCursor.position = rightCursorPoint;
}



/**
  显示光标
 */
- (void)showCursor{
    
    if (self.selectedTextRange.length == 0 || self.selectedTextRange.location == NSNotFound ) {
        return;
    }
    
    [self removeCursor];

    [self addSubview:self.startCursor];
    [self addSubview:self.endCursor];
    
    [self setNeedsDisplay];
}


/**
 移除光标
 */
- (void)removeCursor{
    
    [self.startCursor removeFromSuperview];
    [self.endCursor removeFromSuperview];
    
}

/**
 绘制背景颜色

 @param array  背景区域数组
 */
- (void)drawBackgroundFromRects:(NSArray<NSString*>*)rects{
    if (!rects || 0 == rects.count) {
        return;
    }
    
    UIColor* fillColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:0.2];;
    [fillColor setFill];
    
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    
    [rects enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectFromString(obj);
        CGPathAddRect(mutablePath, nil, rect);
    }];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, mutablePath);
    CGContextFillPath(context);
    CGPathRelease(mutablePath);
    
}

- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location)
    {
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location + first.length)
    {
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }
    return result;
}

/**
 计算选中文字区间对应的区域
 
 @param selectRange 选中字符区间
 @return 文本视图中的区域
 */
- (NSArray<NSString*>*)selectRectsOfRange:(NSRange)selectRange
{
    if (selectRange.length == 0 || selectRange.location == NSNotFound) {
        return nil;
    }
    
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines(self.data.ctFrame);
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0,0), origins);
    
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectRange];
        if (intersection.length > 0) {
            
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    return [pathRects copy];
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
    
    
    if (UIGestureRecognizerStateBegan == recognizer.state ||
        UIGestureRecognizerStateChanged == recognizer.state) {
        
        CFIndex touchIndex =  [self.data touchIndexOfTouchPoint:point rectHeight:self.bounds.size.height];
        
        if (touchIndex != -1) {
            NSRange range = [self.data characterRangeAtIndex:touchIndex];
            self.selectedTextRange = range;
        }
    }
    else{

    }
    
}


- (void)userPanGestureDeteched:(UIPanGestureRecognizer*)panGestureRecognizer{
    CGPoint touchPoint = [panGestureRecognizer locationInView:self];
    if (UIGestureRecognizerStateBegan == panGestureRecognizer.state ) {
        [self addSubview:self.magnifierView];
        [self.magnifierView setTouchPoint:touchPoint];
    }
    else if(UIGestureRecognizerStateChanged == panGestureRecognizer.state){
        [self.magnifierView setTouchPoint:touchPoint];
    }
    else if (UIGestureRecognizerStateEnded == panGestureRecognizer.state){
        [self.magnifierView removeFromSuperview];
    }
}


- (void)userLongGestureDeteched:(UILongPressGestureRecognizer*)longRecognizer{
    CGPoint touchPoint = [longRecognizer locationInView:self];
    
    if (UIGestureRecognizerStateBegan == longRecognizer.state ||
        UIGestureRecognizerStateChanged == longRecognizer.state) {
        CFIndex selectIndex = [self.data touchIndexOfTouchPoint:touchPoint rectHeight:self.bounds.size.height];
        if (selectIndex != -1) {
            NSRange range = [self.data characterRangeAtIndex:selectIndex];
            self.selectedTextRange = range;
        }
    }
    else{
        [self showCursor];
        [self setNeedsDisplay];
    }
}

@end

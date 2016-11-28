//
//  TELabel.m
//  CoreText
//
//  Created by zhangguang on 16/11/24.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TELabel.h"
#import "TELabelLayoutManager.h"

@interface TELabel () <NSLayoutManagerDelegate>

/**
 NSMutableAttributedString 子类，存储字符串文本和文本的相关属性，当textstorege属性发生变化时，会通知
 layoutManager进行排版
 */
@property (nonatomic,strong) NSTextStorage* textStorage;


/**
 定义布局方式，使文本按照一定的布局方式进行排版
 */
@property (nonatomic,strong) TELabelLayoutManager* layoutManager;


/**
 定义排版区域，区域可以是圆形甚至是不规则图形，也可以定义不能填充的区域来显示非文本元素
 */
@property (nonatomic,strong) NSTextContainer* textContatiner;

@end

@implementation TELabel

#pragma mark - *** Properties ***
- (NSTextStorage*)textStorage
{
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] init];
    }
    return _textStorage;
}


- (NSLayoutManager*)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [[TELabelLayoutManager alloc] init];
        _layoutManager.allowsNonContiguousLayout = NO;
        _layoutManager.delegate = self;
    }
    return _layoutManager;
}

- (NSTextContainer*)textContatiner
{
    if (!_textContatiner) {
        _textContatiner = [[NSTextContainer alloc] init];
        _textContatiner.maximumNumberOfLines = 1;
        _textContatiner.lineBreakMode = NSLineBreakByCharWrapping;
        _textContatiner.lineFragmentPadding = 0.0f;
        _textContatiner.size = self.frame.size;
    }
    return _textContatiner;
}

#pragma mark - *** Initializer ****
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

#pragma mark *** Helper ***
- (void)configure{
    [self.layoutManager addTextContainer:self.textContatiner];
    [self.textStorage addLayoutManager:self.layoutManager];
}

/**
 计算textContainer的大小

 @param size 视图大小
 @return container的实际大小
 */
- (CGSize)textContatinerSizeWithBoundsSize:(CGSize)size{
    CGFloat width = fmaxf(0, size.width - self.textInsets.left - self.textInsets.right);
    CGFloat height = fmaxf(0, size.height - self.textInsets.top - self.textInsets.bottom);
    return CGSizeMake(width, height);
    //return self.bounds.size;
}

/**
 计算文本的绘制起点

 @param size 文本需要的绘制区域大小
 @return 绘制起点
 */
- (CGPoint)textOffetWithTextSize:(CGSize)size
{
    CGPoint textOffset = CGPointZero;
    ////根据insets和默认垂直居中来计算出偏移
   // textOffset.x = _textInsets.left;
    //CGFloat paddingHeight = (self.textContatiner.size.height - size.height) / 2.0f;
    //textOffset.y = paddingHeight+_textInsets.top;
   // textOffset.y = _textInsets.top;
    textOffset.x = (self.bounds.size.width - size.width) / 2;
    textOffset.y = 18;//_textInsets.top ;
    return textOffset;
}


#pragma mark - *** SetTextContatinerSize ***
- (void)resizeTextContainerSize
{
    self.textContatiner.size = [self textContatinerSizeWithBoundsSize:self.bounds.size];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeTextContainerSize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeTextContainerSize];
}

- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    _textInsets = textInsets;
    [self resizeTextContainerSize];
    
    //重新计算控件内置大小
    [self invalidateIntrinsicContentSize];
}

#pragma mark - *** Draw ***
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.textContatiner.size.width<=0||self.textContatiner.size.height<=0){
        return;
    }
    self.textContatiner.size = [self textContatinerSizeWithBoundsSize:self.bounds.size];
    
    //根据textContatiner的size和layoutManager 来得到实际的绘制区间
    NSRange range = [self.layoutManager glyphRangeForTextContainer:self.textContatiner];
    NSLog(@" range %@",NSStringFromRange(range));
    
    //获取绘制区域大小
    CGRect drawBounds = [self.layoutManager usedRectForTextContainer:self.textContatiner];
    NSLog(@"drawbounds %@",NSStringFromCGRect(drawBounds));
    
    CGPoint textOffset = [self textOffetWithTextSize:drawBounds.size];
    
    [self.layoutManager drawBackgroundForGlyphRange:range atPoint:textOffset];
    [self.layoutManager drawGlyphsForGlyphRange:NSMakeRange(0, self.textStorage.length) atPoint:textOffset];

}


#pragma mark - *** Api ***
- (void)setAttributedText:(NSAttributedString *)attributedText
{

    
    //计算文本大小
    CGSize size =  [attributedText boundingRectWithSize:CGSizeMake(350, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    NSLog(@"attributeText %@",NSStringFromCGSize(size));
    self.textContatiner.size = size;
    
    [self.textStorage setAttributedString:attributedText];
}


@end

//
//  CTFrameParserConfig.h
//  CoreText
//
//  Created by birneysky on 15/11/28.
//  Copyright © 2015年 birneysky. All rights reserved.
//

/*
 
 用于配置绘制的参数，文字颜色，大小，行间距
 */

#import <UIKit/UIKit.h>


@interface CTFrameParserConfig : NSObject

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat fontSize;

@property (nonatomic,assign) CGFloat lineSpace;

@property (nonatomic,strong) UIColor* textColor;

@end

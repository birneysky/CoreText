//
//  CoreTextData.h
//  CoreText
//
//  Created by birneysky on 15/11/29.
//  Copyright © 2015年 birneysky. All rights reserved.
//

/**
 
 
 Company
    sale
        west
            sale1
        east
        north
        sourth
    product
        design
    develop
        android
        ios
        winows
        mac os
    test
        test1
        test2
        .....
    humam reosource
        meiemei
        .......
 
 
    Node
        id 
        name
 
    group : node
    {
        Array<node> children = new ArrryList<Node>();
    }
 
    memeber : node
    {
    }
 
 
 
    Array dataSource = [Company];
 */

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (nonatomic,assign) CTFrameRef ctFrame;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,copy) NSString* contentText;

@property (nonatomic,strong) NSArray* imageArray;



/**
 根据用户手指的坐标获得 文字在整个字符串的index
 
 @param point 当前手指的坐标
 @param height 文本区域的高度
 @return 文字索引
 */
- (CFIndex)touchIndexOfTouchPoint:(CGPoint)point rectHeight:(CGFloat)height;


/**
 根据字符索引返回，返回索引对应的字符区间

 @param index 文字索引
 @return 字符区间
 */
- (NSRange)characterRangeAtIndex:(NSInteger)index;




@end

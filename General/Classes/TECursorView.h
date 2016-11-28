//
//  TECursorView.h
//  CoreText
//
//  Created by zhangguang on 16/11/28.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TECursorStyle){
    TECursorStyleEnd,
    TECursorStyleStart
};


@interface TECursorView : UIView

@property (nonatomic,assign) TECursorStyle style;

@property (nonatomic,strong) UIColor* color;


- (instancetype)initWithFrame:(CGRect)frame style:(TECursorStyle)style;

@end

//
//  TEMagnifierView.h
//  CoreText
//
//  Created by zhangguang on 16/11/29.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEMagnifierView : UIView

@property (nonatomic,weak) UIView* magnifiedTagetView;

@property (nonatomic,assign) CGPoint touchPoint;

@end

//
//  TELabel.h
//  CoreText
//
//  Created by zhangguang on 16/11/24.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TELabel : UIView


@property (nonatomic, assign) UIEdgeInsets textInsets;

- (void)setAttributedText:(NSAttributedString *)attributedText;


@end

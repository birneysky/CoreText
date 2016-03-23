//
//  CTFrameParser.h
//  CoreText
//
//  Created by birneysky on 15/11/28.
//  Copyright © 2015年 birneysky. All rights reserved.
//

/*
 用于生成最后绘制界面的CTFrameRef实例
 */

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject

+ (CoreTextData*)parseContext:(NSString*)content config:(CTFrameParserConfig*)config;

+ (CoreTextData*)parseTemplateFile:(NSString*)path config:(CTFrameParserConfig*)config;

@end

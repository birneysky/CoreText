//
//  CTFrameParser.m
//  CoreText
//
//  Created by birneysky on 15/11/28.
//  Copyright © 2015年 birneysky. All rights reserved.
//

#import "CTFrameParser.h"
#import "CoreTextImageData.h"


static CGFloat ascentCallback(void* ref)
{
    return [[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void* ref)
{
    return 0;
}

static CGFloat widthCallback(void* ref)
{
    return [[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}


@implementation CTFrameParser

+ (NSDictionary*)attributesWithConfig:(CTFrameParserConfig*)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor* textColor = config.textColor;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)(textColor.CGColor);
    dict[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    return dict;
}

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)framesetter
                                config:(CTFrameParserConfig*)config
                                height:(CGFloat) height
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    return frameRef;
}

+ (CoreTextData*)parseContext:(NSString*)content config:(CTFrameParserConfig*)config
{
    NSDictionary* attributes = [self attributesWithConfig:config];
    
    NSAttributedString* contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    //创建CTFrameSetter 实例
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    // 获得绘制区域的高度
    CGSize restrictSize  = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    
    //生成CTFrameRef 实例
    
    CTFrameRef frameRef = [self createFrameWithFrameSetter:frameSetterRef config:config height:textHeight];
    
    CoreTextData* data = [[CoreTextData alloc] init];
    data.ctFrame = frameRef;
    data.height = textHeight;
    data.contentText = contentString.string;
    
    CFRelease(frameRef);
    CFRelease(frameSetterRef);
    
    return data;
}


+ (CoreTextData*)parseTemplateFile:(NSString*)path config:(CTFrameParserConfig*)config
{
    NSMutableArray* imageArray = [[NSMutableArray alloc] init];
    NSAttributedString* content = [self loadTeamplateFile:path config:config imageArray:imageArray];
    CoreTextData* data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    return data;
}


+ (NSAttributedString*)loadTeamplateFile:(NSString*)path
                                  config:(CTFrameParserConfig*)config
                              imageArray:(NSMutableArray*)imageArray
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray*  array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString* type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                   NSAttributedString* as =  [self parseAttributedContentFromNSDictionary:dict
                                                  config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"img"])
                {
                    CoreTextImageData* imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    
                    NSAttributedString* as = [self parseImageDataFromNSDictinory:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;
}


+ (NSAttributedString*)parseAttributedContentFromNSDictionary:(NSDictionary*)dict config:(CTFrameParserConfig*)config
{
    NSMutableDictionary* attributes = (NSMutableDictionary*)[self attributesWithConfig:config];
    UIColor* color = [self colorFromTempplate:dict[@"color"]];
    
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString* content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor*)colorFromTempplate:(NSString*)name
{
    if ([name isEqualToString:@"bule"]) {
        return [UIColor blueColor];
    }
    else if ([name isEqualToString:@"red"])
    {
        return [UIColor redColor];
    }
    else if ([name isEqualToString:@"black"])
    {
        return [UIColor blackColor];
    }
    else
    {
        return nil;
    }
}

+ (CoreTextData*)parseAttributedContent:(NSAttributedString*) content config:(CTFrameParserConfig*)config
{
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    
    CTFrameRef frame = [self createFrameWithFrameSetter:frameSetter config:config height:textHeight];
    
    CoreTextData* data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.contentText = content.string;
    
    CFRelease(frameSetter);
    CFRelease(frame);
    
    return data;
}


+ (NSAttributedString*)parseImageDataFromNSDictinory:(NSDictionary*)dict
                                              config:(CTFrameParserConfig*)config
{
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(dict));
    unichar objectReplacementChar = 0xfffc;
    NSString* content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary* attributes = [self attributesWithConfig:config];
    NSMutableAttributedString* space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    
    return space;
}




@end

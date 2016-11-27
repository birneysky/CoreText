//
//  ViewController.m
//  CoreText
//
//  Created by birneysky on 15/11/28.
//  Copyright © 2015年 birneysky. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "UIView+frameAdjust.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContstraint;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //DebugLog(@"self view width %f",self.view.width);
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    DebugLog(@"self view width %f",self.view.width);
    DebugLog(@"ctView width %f",self.ctView.width);
}

- (void)viewWillLayoutSubviews
{
    DebugLog(@"self view width %f",self.view.width);
    DebugLog(@"ctView width %f",self.ctView.width);
}

- (void)viewDidLayoutSubviews
{
    DebugLog(@"self view width %f",self.view.width);
    DebugLog(@"ctView width %f",self.ctView.width);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DebugLog(@"self view width %f",self.view.width);
    DebugLog(@"ctView width %f",self.ctView.width);
    // Do any additional setup after loading the view, typically from a nib.
    CTFrameParserConfig* config = [[CTFrameParserConfig alloc] init];
    //config.textColor = [UIColor redColor];
    config.width = 240;
//    NSLog(@" width = %f",self.ctView.width);
//    NSLog(@" widht = %f",self.view.frame.size.width);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"json"];
    CoreTextData* data = [CTFrameParser parseTemplateFile:path config:config];
//    CoreTextData* data = [CTFrameParser parseContext:@"发达了手机费飞机多拉风都是"
//                          "分老大撒楼房的萨拉反对了撒反垄断撒了法律的撒代理费拉屎了分手打了到拉萨疯了打算理发"
//                          "\n\n到拉萨分老大撒楼房的萨拉发来撒附近的沙拉飞机呆里撒奸多了几分拉大手机福利都睡啦房间里的撒减肥了的撒家里是大家老地方撒减肥了的撒加路费多少啦到拉萨\n房间里的撒减肥了的撒了老对手减肥了的撒了罚款都是拉飞机到拉萨家里的数据反馈了的撒减肥了的撒考虑房价多少了代理商房间里的撒娇法律的撒娇老对手拉飞机的拉萨房间里的撒娇了到拉萨房间里的撒减肥了的撒劳动手机阿里附近" config:config];
    self.ctView.data = data;
    //self.ctView.height = data.height;
    self.heightContstraint.constant = data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

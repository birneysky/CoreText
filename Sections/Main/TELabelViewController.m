//
//  TELabelViewController.m
//  CoreText
//
//  Created by zhangguang on 16/11/24.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TELabelViewController.h"
#import "TELabel.h"
#import "TETextAttachment.h"

@interface TELabelViewController ()
@property (weak, nonatomic) IBOutlet TELabel *label;

@end

@implementation TELabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"OriginalExpression" ofType:@"bundle"];
    NSString* imageName = [path stringByAppendingPathComponent:@"Expression_1"];
    UIImage* image1 = [UIImage imageNamed:imageName];
    TETextAttachment* textAttachment1 = [[TETextAttachment alloc] init];
    textAttachment1.image = image1;
    //textAttachment1.bounds = CGRectMake(0, -2, 24,24);
    
    
    UIImage* image2 = [UIImage imageNamed:[path stringByAppendingPathComponent:@"Expression_2"]];
    TETextAttachment* textAttachment2 = [[TETextAttachment alloc] init];
    textAttachment2.image = image2;
    //textAttachment2.bounds = CGRectMake(0, -2, 24, 24);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = 25;
 //   paragraph.lineHeightMultiple = 1.1;
    
    UIImage* image3 = [UIImage imageNamed:@"coretext-image-2"];
    TETextAttachment* textAttachment3 = [[TETextAttachment alloc] init];
    textAttachment3.image = image3;
    
    //
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:@"鹅鹅鹅，曲项向天歌，白毛浮绿水，红掌拨清波。锄禾日当午，汗滴禾下土，谁知盘中餐，粒粒皆辛苦。青青子衿，悠悠我心，譬如朝露，去日苦多，慨当以慷，忧思难忘" attributes:@{NSParagraphStyleAttributeName:paragraph,NSFontAttributeName:[UIFont systemFontOfSize:30.0f]}];
    [attributeString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment1]];
    [attributeString insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment2] atIndex:20];
    [attributeString insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment3] atIndex:0];
    [self.label setAttributedText:attributeString];
    self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  CirculViewController.m
//  CoreText
//
//  Created by birneysky on 16/11/28.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "CirculViewController.h"
#import "CirculeView.h"

@interface CirculViewController ()
@property (weak, nonatomic) IBOutlet CirculeView *circulView;

@end

@implementation CirculViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.circulView.startValue = 0.5;
    self.circulView.lineWidth = 5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.circulView.value = 1.0;
    });
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

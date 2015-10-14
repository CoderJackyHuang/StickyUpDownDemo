//
//  ViewController.m
//  ObjCStickyDemo
//
//  Created by huangyibiao on 15/10/14.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()
- (IBAction)enterToLearnButtonClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Demo";
}

- (IBAction)enterToLearnButtonClicked:(id)sender {
  DemoViewController *vc = [[DemoViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

@end

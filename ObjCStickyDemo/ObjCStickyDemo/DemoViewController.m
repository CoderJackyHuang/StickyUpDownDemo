//
//  DemoViewController.m
//  ObjCStickyDemo
//
//  Created by huangyibiao on 15/10/14.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "DemoViewController.h"

@interface UIView (frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat bottomY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation UIView (frame)

- (CGFloat)x {
  return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)y {
  return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (void)setBottomY:(CGFloat)bottomY {
  CGRect frame = self.frame;
  frame.origin.y = bottomY - self.frame.size.height;
  self.frame = frame;
}

- (CGFloat)bottomY {
  return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

@end

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *headerView;
// 要固定的视图
@property (nonatomic, strong) UILabel *stickyView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"跟着学习";
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  CGFloat w = [UIScreen mainScreen].bounds.size.width;
  self.headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 80)];
  self.headerView.backgroundColor = [UIColor redColor];
  self.headerView.textAlignment = NSTextAlignmentCenter;
  self.headerView.text = @"我要随着滚动而慢慢消失或者出现";
  self.headerView.textColor = [UIColor whiteColor];
  [self.view addSubview:self.headerView];
  
  self.stickyView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerView.bottomY, w, 50)];
  self.stickyView.backgroundColor = [UIColor greenColor];
  [self.view addSubview:self.stickyView];
  self.stickyView.textColor = [UIColor whiteColor];
  self.stickyView.textAlignment = NSTextAlignmentCenter;
  self.stickyView.text = @"滚动到一定位置就固定";
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.stickyView.bottomY, w, self.view.height - self.stickyView.bottomY)];
  [self.view addSubview:self.tableView];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.decelerationRate = 0.1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // 保证是我们的tableivew
  if (scrollView == self.tableView) {
    // 保证我们是垂直方向滚动，而不是水平滚动
    if (scrollView.contentOffset.x == 0) {
      CGFloat y = scrollView.contentOffset.y;
      
      // 这个是非常关键的变量，用于记录上一次滚动到哪个偏移位置
      static CGFloat previousOffsetY = 0;
      
      // 向上滚动
      if (y > 0) {
        if (self.headerView.bottomY <= 0) {
          return;
        }
        
        // 计算两次回调的滚动差:fabs(y - previousOffsetY)值
        CGFloat bottomY = self.headerView.bottomY - fabs(y - previousOffsetY);
        bottomY = bottomY >= 0 ? bottomY : 0;
        self.headerView.bottomY = bottomY;
        self.stickyView.y = self.headerView.bottomY;
        self.tableView.frame = CGRectMake(0, self.stickyView.bottomY,
                                          scrollView.width,
                                          self.view.height - self.stickyView.bottomY);
        
        previousOffsetY = y;
        
        // 如果一直不松手滑动，重复向上向下滑动时，如果没有设置还原为0，则会出现马上到顶的情况。
        if (previousOffsetY >= self.headerView.height) {
          previousOffsetY = 0;
        }
      }
      // 向下滚动
      else if (y < 0) {
        if (self.headerView.y >= 0) {
          return;
        }
        
        CGFloat bottomY = self.headerView.bottomY + fabs(y);
        bottomY = bottomY <= self.headerView.height ? bottomY : self.headerView.height;
        
        self.headerView.bottomY = bottomY;
        self.stickyView.y = self.headerView.bottomY;
        self.tableView.frame = CGRectMake(0,
                                          self.stickyView.bottomY,
                                          scrollView.width,
                                          self.view.height - self.stickyView.bottomY);
      }
    }
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"CellIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  
  cell.textLabel.text = @"这只是展示固定数据，没有别的作用。";
  
  return cell;
}

@end

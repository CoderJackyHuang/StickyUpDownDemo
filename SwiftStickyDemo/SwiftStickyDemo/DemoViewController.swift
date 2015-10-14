//
//  DemoViewController.swift
//  SwiftStickyDemo
//
//  Created by huangyibiao on 15/10/14.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  var x: CGFloat {
    get { return self.frame.origin.x }
    set { self.frame.origin.x = newValue }
  }
  
  var y: CGFloat {
    get { return self.frame.origin.y }
    set { self.frame.origin.y = newValue }
  }
  
  var bottomY: CGFloat {
    get { return self.frame.origin.y + self.frame.size.height }
    set { self.frame.origin.y = newValue - self.frame.size.height }
  }
  
  var width: CGFloat {
    get { return self.frame.size.width }
    set { self.frame.size.width = newValue }
  }
  
  var height: CGFloat {
    get { return self.frame.size.height }
    set { self.frame.size.height = newValue }
  }
}

class DemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var tableView = UITableView()
  var headerView = UILabel()
  var stickyView = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.whiteColor()
    self.automaticallyAdjustsScrollViewInsets = true
    self.edgesForExtendedLayout = .None
    
    let w = UIScreen.mainScreen().bounds.size.width
    
    headerView.backgroundColor = UIColor.greenColor()
    headerView.textColor = UIColor.whiteColor()
    headerView.textAlignment = .Center
    headerView.frame = CGRectMake(0, 0, w, 80)
    self.view.addSubview(headerView)
    
    stickyView.backgroundColor = UIColor.redColor()
    stickyView.textColor = UIColor.whiteColor()
    stickyView.textAlignment = .Center
    stickyView.frame = CGRectMake(0, headerView.bottomY, w, 50)
    self.view.addSubview(stickyView)
    
    tableView.frame = CGRectMake(0, stickyView.bottomY, w, self.view.height - stickyView.bottomY)
    tableView.delegate = self
    tableView.dataSource = self
    self.view.addSubview(tableView)
  }
  
  // MARK: - UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "cellIdentifier"
    
    var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    cell?.textLabel?.text = "这只是测试显示数据"
    
    return cell!
  }
  
  // MARK: - UIScrollViewDelegate
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView === tableView {
      if scrollView.contentOffset.x == 0 {
        let y = scrollView.contentOffset.y
        
        // 向上滚动
        if y > 0 {
          struct Diff {
            static var previousY: CGFloat = 0.0
          }
          
          guard headerView.bottomY > 0.0 else {
            return
          }
          
          var bottomY = headerView.bottomY - fabs(y - Diff.previousY)
          bottomY = bottomY >= 0.0 ? bottomY : 0.0
          headerView.bottomY = bottomY
          stickyView.y = headerView.bottomY
          tableView.frame = CGRectMake(0, stickyView.bottomY, tableView.width, self.view.height - stickyView.bottomY)
          
          Diff.previousY = y
          
          if Diff.previousY >= headerView.height {
            Diff.previousY = 0
          }
        }
        // 向下滚动
        else if y < 0 {
          if headerView.y >= 0 {
            return
          }
          
          var bottomY = headerView.bottomY + fabs(y)
          bottomY = bottomY <= headerView.height ? bottomY : headerView.height
          headerView.bottomY = bottomY
          stickyView.y = headerView.bottomY
          tableView.frame = CGRectMake(0, stickyView.bottomY, tableView.width, self.view.height - stickyView.bottomY)
        }
      }
    }
  }
}
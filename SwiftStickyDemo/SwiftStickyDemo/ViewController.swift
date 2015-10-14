//
//  ViewController.swift
//  SwiftStickyDemo
//
//  Created by huangyibiao on 15/10/14.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBAction func onEnterToLearnClicked(sender: AnyObject) {
    let vc = DemoViewController()
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}


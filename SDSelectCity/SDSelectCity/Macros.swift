//
//  Macros.swift
//  SDSelectCity
//
//  Created by slowdony on 2019/11/29.
//  Copyright © 2019 slowdony. All rights reserved.
//

import UIKit

//MARK:--当前屏幕尺寸
let kScreenW = UIScreen.main.bounds.width /// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height /// 屏幕高度
let kScreenBounds:CGRect = UIScreen.main.bounds /// 屏幕bounds
//MARK:--状态栏尺寸
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height /// 状态栏高度
let kNavBarHeight:CGFloat = 44.0 /// 导航高度
let kNavTopHeight:CGFloat = kStatusBarHeight + kNavBarHeight ///整个导航栏高度
//MARK:--底部tabbar高度
let kTabBarHeight:CGFloat = kStatusBarHeight > 20 ? 83 :49

//MARK:--Color颜色
func ColorHex(_ hexValue: Int) -> UIColor {
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,alpha: 1.0)}
func ColorHexA(_ hexValue: Int,_ alpha: CGFloat) -> UIColor {
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,alpha: alpha) }



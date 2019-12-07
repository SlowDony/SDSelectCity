//
//  SDCityModel.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/19.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit

class SDCityInitial: NSObject {
    //首字母
    @objc var initial :NSString?
    //
    @objc var cityArr :NSMutableArray?
}


class SDCityModel: NSObject {
    @objc var code :NSString?
    @objc var name :NSString?
    @objc var pid : NSInteger = 0
    @objc var id : NSInteger = 0
    @objc var spell :NSString?{
        didSet{
            if(spell!.length>0){
                self.firstLetter = spell? .substring(with: NSRange(location: 0, length: 1)) as NSString?
            }
        }
    }
    //自定义字段 首字母
    @objc var firstLetter :NSString?
}


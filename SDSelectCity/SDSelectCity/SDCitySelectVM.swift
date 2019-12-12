//
//  SDCitySelectVM.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/19.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit

class SDCitySelectVM: NSObject {
    
    lazy var hotCityArr: NSMutableArray = {
        let hotCityArr = NSMutableArray.init()
        return hotCityArr
    }()
    
    lazy var rootDataArr: NSMutableArray = {
           let rootDataArr = NSMutableArray.init()
           return rootDataArr
    }()
    
    lazy var firstLetterArray: NSMutableArray = {
           let firstLetterArray = NSMutableArray.init()
           return firstLetterArray
    }()
    
    lazy var allCityArray:NSMutableArray = {
        let allCityArray = NSMutableArray.init()
        return allCityArray
    }()
    
    func getCityListNetWork(callBack:@escaping ((Bool)->())) {
        
        let cityListPath:String = Bundle.main.path(forResource: "City", ofType: "plist") ?? ""
        let cityListDataArr :NSArray = NSArray(contentsOfFile: cityListPath)!
        
        let allCityArr = NSMutableArray()
        
        for dic in cityListDataArr as! [NSDictionary]{
            
            let arr = dic["children"] as! NSArray
            if (arr.count>0){
                for dic in arr as! [NSDictionary]{
                   
                   let cityModel =  SDCityModel()
                    cityModel.spell = dic["spell"] as? NSString
                    cityModel.id = dic["id"] as? NSInteger ?? 0
                    cityModel.name = dic["name"] as? NSString
                    cityModel.pid = dic["pid"] as? NSInteger ?? 0
                    
                   allCityArr .add(cityModel)
                }
            }
        }
        
        self.allCityArray = NSMutableArray(array: allCityArr)
        
        //去重
        let firstLetterArray = allCityArr.value(forKeyPath: "@distinctUnionOfObjects.firstLetter") as![String]
        self.firstLetterArray = NSMutableArray(array: firstLetterArray)
        
        for firstLetter in firstLetterArray{
            let cityInital =  SDCityInitial()
            cityInital.initial = firstLetter as NSString
            cityInital.cityArr = NSMutableArray.init()
            let emptyArr = NSMutableArray.init()
            for cityModel in allCityArr as! [SDCityModel]{
               
                if  cityModel.firstLetter! as String == firstLetter {
                    emptyArr .add(cityModel)
                }
                cityInital.cityArr = emptyArr
            }
            self.rootDataArr .add(cityInital)
        }
    
       let hotCity = SDCityInitial()
        hotCity.initial = "热门城市"
        
        let bjCity = SDCityModel()
        bjCity.name = "北京"
        let shCity = SDCityModel()
        shCity.name = "上海"
        let cqCity = SDCityModel()
        cqCity.name = "重庆"
        let xaCity = SDCityModel()
        xaCity.name = "西安"
        let hzCity = SDCityModel()
        hzCity.name = "杭州"
        let tjCity = SDCityModel()
        tjCity.name = "天津"
        
        hotCity.cityArr = [bjCity,shCity,cqCity,xaCity,hzCity,tjCity]
        self.rootDataArr .insert(hotCity, at: 0)
        
        callBack(true)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

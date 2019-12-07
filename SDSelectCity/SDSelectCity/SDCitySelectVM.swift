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
        
        //去重
        let firstLetterArray = allCityArr.value(forKeyPath: "@distinctUnionOfObjects.firstLetter") as![String]
        print(firstLetterArray)
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
       
        for cityInital in self.rootDataArr  {
            print((cityInital as! SDCityInitial).cityArr?.count as Any)
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
        print(self.rootDataArr)
        callBack(true)
        
        
//        BPHealthHomeServer.getAreaCityHotSuccess({(obj,msg,info) in
//
//            let dataDic = obj as! NSDictionary
//
//            let hotModelArr :[SDCityModel] = NSArray.yy_modelArray(with: SDCityModel.self, json: dataDic["hotAreas"] ?? []) as! [SDCityModel]
//            self.hotCityArr .addObjects(from: hotModelArr)
//
//            let cityModelArr :[SDCityModel] = NSArray.yy_modelArray(with: SDCityModel.self, json: dataDic["citys"] ?? []) as![SDCityModel]
//
//            let dataArr = NSMutableArray(array: cityModelArr)
//
//            let firstLetterArray = dataArr.value(forKeyPath: "@distinctUnionOfObjects.firstLetter") as![String]
//            self.firstLetterArray = NSMutableArray(array: firstLetterArray)
//            for str in firstLetterArray{
//                let cityInitial = SDCityInitial()
//                cityInitial.initial = str as NSString
//                cityInitial.cityArr = NSMutableArray.init()
//                for cityModel in cityModelArr{
//                    if((cityModel.firstLetter! as String) == str){
//                        cityInitial.cityArr?.add(cityModel)
//                    }
//                }
//                self.rootDataArr .add(cityInitial)
//            }
//
//            let cityInitial = SDCityInitial()
//            cityInitial.initial = "热门城市"
//            cityInitial.cityArr = NSMutableArray(array: self.hotCityArr)
//            self.rootDataArr .insert(cityInitial, at: 0)
//
//            callBack(true)
//
//
//        }) { (error, msg,info ) in
//            callBack(false)
//        }
    }
    func getJSONStringFromArray(array:NSArray) -> String {
         
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
         
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
         
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

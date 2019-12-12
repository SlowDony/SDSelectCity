//
//  SDLocationManager.swift
//  SDSelectCity
//
//  Created by slowdony on 2019/12/10.
//  Copyright © 2019 slowdony. All rights reserved.
//

/*
 
  kCLAuthorizationStatusNotDetermined  //用户没有选择是否要使用定位服务（弹框没选择，或者根本没有弹框）

  kCLAuthorizationStatusRestricted          //定位服务授权状态受限制，可能由于活动限制了定位服务，并且用户不能改变当前的权限，这个状态有可能不是用户拒绝的，但是也有可能是用户拒绝的。官网说的，具体没遇到过（遇到过的童鞋请告知谢谢）

  kCLAuthorizationStatusDenied               //用户在设置中关闭定位功能，或者用户明确的在弹框之后选择禁止定位

  kCLAuthorizationStatusAuthorized        //用户已经明确使用定位功能

  kCLAuthorizationStatusAuthorizedWhenInUse  //用户在使用期间允许使用定位功能

  kCLAuthorizationStatusAuthorizedAlways          //App始终允许使用定位功能
 */

import UIKit
import CoreLocation

typealias CityPositionBlock = (String,String) -> ()
class SDLocationManager: NSObject {
    
   static let shared = SDLocationManager()

   private var viewController : UIViewController?
   private var locationM : CLLocationManager?
    var cityPositionBlock : CityPositionBlock?
    lazy var geoCoder: CLGeocoder = {
           return CLGeocoder()
    }()
    
    func startLocation() {
        self.locationM! .startUpdatingLocation()
    }
    
    func startPositing( vc:UIViewController) {
        
        viewController = vc
        if(CLLocationManager.authorizationStatus() == .denied){
            alert(viewController: viewController!)
        }else{
            requestLocationServicesAuthrozation()
        }
        
    }
    
    func alert(viewController:UIViewController) {
        let alertVC = UIAlertController (title: "定位服务未开启,是否前往开启?", message: "请进入系统[设置]->[隐私]->[定位服务]中打开开关，并允许\"\(AppName)\"使用定位服务", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let setAction = UIAlertAction(title: "设置", style: .default) { (action) in
            let url = URL.init(string: UIApplication.openSettingsURLString)
            if UIApplication .shared .canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        alertVC .addAction(cancelAction)
        alertVC .addAction(setAction)
        viewController .present(alertVC, animated: true, completion: nil)
    }
    
    func requestLocationServicesAuthrozation() {
        
        if (self.locationM == nil){
            self.locationM = CLLocationManager()
            self.locationM?.delegate = self
        }
        self.locationM?.requestWhenInUseAuthorization()
        self.locationM?.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == .notDetermined){
            locationM?.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationM?.desiredAccuracy = kCLLocationAccuracyBest
            let distance : CLLocationDistance = 10.0
            locationM?.distanceFilter = distance
            locationM?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationM?.startUpdatingLocation()
        }
    }
    
    func reportLocationServicesAuthorizationStatus(states:CLAuthorizationStatus) {
        if states == .notDetermined{ //用户没有选择是否要使用定位服务（弹框没选择，或者根本没有弹框）
            requestLocationServicesAuthrozation()
        }else if states == .restricted || states == .denied{
            alert(viewController: viewController!)
        }
    }
}

extension SDLocationManager:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last
            else {
            print("失败1")
            return
        }
            print(newLocation)//<+31.26514482,+121.61259089> +/- 50.00m (speed 0.00 mps / course -1.00) @ 2016/11/14 中国标准时间 14:49:51
        if newLocation.horizontalAccuracy < 0 {
            print("失败2")
            return
        }
         geoCoder.reverseGeocodeLocation(newLocation) { (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                print("22222\(pl.locality!)22222")//上海市
                
                UserDefaults.standard .set(pl.locality, forKey: "locationCityName")
                if self.cityPositionBlock != nil{
                    self.cityPositionBlock!(pl.locality!,"")
                }
            }else{
                print("定位失败")
                if self.cityPositionBlock != nil {
                    self.cityPositionBlock!("","定位失败")
                }
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if self.cityPositionBlock != nil {
            self.cityPositionBlock!("","定位失败")
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("定位状态改变")
        reportLocationServicesAuthorizationStatus(states: status)
    }
    
}

//
//  BPCitySelectViewController.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/13.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit
import CoreLocation

class SDCitySelectVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,BPHotCityCellDelegate{
    @objc var selectResultBlock:((SDCityModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .setupUI()
        self .cityNetWork()
        self.locationM.startUpdatingLocation()
        
    }
    
    lazy var currentCityView:SDCitySelectHeadView = {
        let currentCityView  = SDCitySelectHeadView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 114+12))
         currentCityView.locationBtnClickBlock = {
            self.currentCityView .setLocationButtonState(state: .positioning)
            self.locationM.startUpdatingLocation()
        }
        currentCityView.currentBtnClickBlock = {(sender:UIButton) in
           let cityModel = SDCityModel()
           var cityName = sender.titleLabel?.text
           cityName = cityName?.replacingOccurrences(of: " ", with: "")
           cityModel.name = cityName as NSString?
            if let selectResultBlock = self.selectResultBlock {
                selectResultBlock(cityModel)
            }
            self.navigationController? .popToRootViewController(animated: true)
        }
        return currentCityView
    }()
    
    
    lazy var searchBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 30, y: 8, width: kScreenW-60, height: 28)
        btn .setTitle("城市名/拼音", for: UIControl.State.normal)
        btn .setTitleColor(ColorHex(0xAEAEAE), for: UIControl.State.normal)
        btn.backgroundColor = ColorHex(0xF1F1F1)
        btn.titleLabel?.font =  UIFont .systemFont(ofSize: 14)
        btn .setImage(UIImage.init(named: "nav_search"), for: UIControl.State.normal)
        btn .addTarget(self, action: #selector(searchBtnClick), for: UIControl.Event.touchUpInside)
        btn.layer.cornerRadius = 28/2
        btn.layer.masksToBounds = true
        //        btn.intrinsicContentSize = CGSize(width: kScreenW-60, height: 28)
        return btn
    }()
    
    
    lazy var locationM: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.delegate = self
        if #available(iOS 8.0, *) {
          locationM.requestAlwaysAuthorization()
        }
        return locationM
    }()
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    @objc func searchBtnClick() {
        
        let vc = SDCitySelectSearchVC()
        vc.searchResultBlock = self.selectResultBlock
        self.navigationController? .pushViewController(vc, animated: false)
    }
    
    lazy var citySelectVM: SDCitySelectVM = {
        let citySelectVM = SDCitySelectVM()
        
        return citySelectVM
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds
            , style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        tableView.sectionIndexColor = ColorHex(0xFF6D3D)
        return tableView
    }()
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SDCitySelectVC{
    func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.titleView = self.searchBtn
        
        self.tableView.tableHeaderView = self.currentCityView;
        
        self.view .addSubview(self.tableView)
    }
}

// MARK:  tableview代理
extension SDCitySelectVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.citySelectVM.rootDataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let cityInitial = self.citySelectVM.rootDataArr[section] as! SDCityInitial
        if(cityInitial.initial! as String == "热门城市")
        {
            return 1
        }
        return cityInitial.cityArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cityInitial = self.citySelectVM.rootDataArr[indexPath.section] as! SDCityInitial
        let cityModel = cityInitial.cityArr?[indexPath.row] as! SDCityModel
        
        if cityInitial.initial! as String == "热门城市"  {
            
            let cell = SDHotCityTableViewCell .B_cellWithTableView(tableView)
            cell.cellDelegate = self
            cell .setCellData(data: cityInitial.cityArr! as NSMutableArray)
            
            return cell
          
        }else {
            
            let cellID = "cellId"
            let cell  = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
            cell.textLabel?.text = cityModel.name as String?
            cell.textLabel?.font =  UIFont .systemFont(ofSize: 14)
            cell.textLabel?.textColor = ColorHex(0x2a2928)
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let cityInitial = self.citySelectVM.rootDataArr[indexPath.section] as! SDCityInitial
        if(cityInitial.initial! as String == "热门城市")
        {
            return SDHotCityTableViewCell.cellHeight(data: cityInitial.cityArr ?? [])
        }
        return 40
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return (self.citySelectVM.firstLetterArray as! [String])
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 52))
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.frame = CGRect(x:16 , y: 20, width: 100, height: 20)
        label.backgroundColor = UIColor.clear
        label.textColor = ColorHex(0x2A2928)
        let cityInitial = self.citySelectVM.rootDataArr[section] as! SDCityInitial
        label.text = cityInitial.initial as String?
        label.textAlignment = NSTextAlignment.left
        label.font =  UIFont .systemFont(ofSize: 14)
        label.numberOfLines = 1
        view .addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 26))
        footView.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect(x: 0, y: 14, width: kScreenW, height: 12))
        view.backgroundColor = ColorHex(0xF8F8F8)
        footView .addSubview(view)
        return footView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 26
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
        let cityInitial = self.citySelectVM.rootDataArr[indexPath.section] as! SDCityInitial
        if(cityInitial.initial! as String == "热门城市"){
            return
        }
        let cityModel = cityInitial.cityArr?[indexPath.row] as! SDCityModel
        
        if let selectResultBlock = selectResultBlock {
            selectResultBlock(cityModel)
        }
        self.navigationController? .popToRootViewController(animated: true)
    }
}
// MARK:BPHotCityCellDelegate
extension SDCitySelectVC{
    func hotCityCellDidSelectItemAt(cityModel: SDCityModel) {
        
        if let selectResultBlock = selectResultBlock {
            selectResultBlock(cityModel)
        }
        self.navigationController? .popToRootViewController(animated: true)
    }
}

extension SDCitySelectVC:CLLocationManagerDelegate{
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
                self.currentCityView .setCurrentCityButtonTitle(title: pl.locality ?? "")
                self.currentCityView .setLocationButtonState(state: .locateComplete)
            }else{
                print("定位失败")
                self.currentCityView .setLocationButtonState(state: .locateFailure)
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.currentCityView .setLocationButtonState(state: .locateFailure)
        
//        let alert = LEEAlert.alert()
//        _ = alert.config
//            .leeTitle("伯图全景温馨提示您")
//            .leeContent("请开启定位服务,已便获取附近信息")
//            .leeAddAction({(action:LEEAction)in
//                action.title = "取消"
//                action.titleColor = ColorHex(0x919090)
//                action.type = .cancel
//            })
//            .leeAddAction({(action:LEEAction)in
//                action.title = "确定"
//                action.titleColor = ColorHex(0xFF8A41)
//                action.clickBlock = {
//                    let url = URL.init(string: UIApplication.openSettingsURLString)
//                    if UIApplication .shared .canOpenURL(url!){
//                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                    }
//                }
//            })
//            .leeShow()
        manager.stopUpdatingLocation()
    }
    
}

extension SDCitySelectVC{
    func cityNetWork()  {
        self.citySelectVM .getCityListNetWork { [weak self](isSuccess:Bool) in
            if(isSuccess){
                self?.tableView .reloadData()
            }
        }
    }
}

//
//  BPCitySelectHeadView.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/14.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit

public enum LocationButtonState : Int {
    /// 未定位
    case notLocate
    /// 正在定位
    case positioning
    /// 定位失败
    case locateFailure
    /// 定位完成
    case locateComplete
}

class SDCitySelectHeadView :UIView{
    
    @objc var locationBtnClickBlock:(() -> Void)?
    
    @objc var currentBtnClickBlock:((_ sender:UIButton) -> Void)?
    override init(frame: CGRect) {
        super .init(frame:frame)
        self .addSubview(self.titleView)
        self .addSubview(self.locationButton)
        
//        self.locationButton.letImageToRight()
        
        self .addSubview(self.currentCityButton)
        self .addSubview(self.line)
        
        let cityName = UserDefaults.standard .object(forKey: "locationCityName")
       if cityName != nil {
        self.currentCityButton.isHidden = true
       }else{
        self .setCurrentCityButtonTitle(title: "哈哈")
       }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.frame = CGRect(x:16 , y: 0, width: 100, height: 62)
        label.backgroundColor = UIColor.clear
        label.textColor = ColorHex(0x2A2928)
        label.text = "当前定位城市"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont .systemFont(ofSize: 14)
        label.numberOfLines = 1
        view .addSubview(label)
        return view
    }()
    
    lazy var locationButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 20, y: 62, width: 166, height: 28)
        btn .setTitle("未定位，点击定位", for: UIControl.State.normal)
        btn .setTitleColor(ColorHex(0xAEAEAE), for: UIControl.State.normal)
        btn.titleLabel?.font =  UIFont .systemFont(ofSize: 14)
        btn .setImage(UIImage.init(named: "icon_loading"), for: UIControl.State.normal)
        btn .addTarget(self, action: #selector(locationButtonClick), for: UIControl.Event.touchUpInside)
       
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = ColorHex(0xD8D8D8).cgColor
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var currentCityButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 206, y: 62, width: 120, height: 28)
        btn .setTitleColor(ColorHex(0x303030), for: UIControl.State.normal)
        btn.titleLabel?.font =  UIFont .systemFont(ofSize: 14)
        btn .setImage(UIImage.init(named: "icon_placeLocator"), for: UIControl.State.normal)
        btn .addTarget(self, action: #selector(currentBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = ColorHex(0xD8D8D8).cgColor
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        return btn
    }()
    lazy var line: UIView = {
        let line = UIView()
        line.frame = CGRect(x: 0, y: 114, width: kScreenW , height: 12)
        line.backgroundColor = ColorHex(0xF8F8F8)
        
        return line
    }()
    
    @objc func currentBtnClick(sender:UIButton)  {
        if self.currentBtnClickBlock != nil{
            self.currentBtnClickBlock?(sender)
        }
    }
    
    @objc func locationButtonClick() {
        if self.locationBtnClickBlock != nil{
            self.locationBtnClickBlock?()
        }
    }
    
    func setCurrentCityButtonTitle(title:String){
        self.currentCityButton.isHidden = false
        self.currentCityButton .setTitle(" \(title)", for: .normal)
    }
    
    func setLocationButtonState(state:LocationButtonState) {
        switch state {
        case .positioning:
            self.locationButton .setTitle("正在定位...", for: .normal)
            self.locationButton .setImage(UIImage.init(), for: .normal)
//            self.locationButton .mas_updateConstraints { (make) in
//                make?.width.mas_equalTo()(120)
//            }
//            self.currentCityButton .mas_updateConstraints { (make) in
//            make?.left.mas_equalTo()(self.locationButton.mas_right)?.offset()(20)
//            }
            self.locationButton.frame = CGRect(x: 20, y: 62, width: 120, height: 28)
            self.currentCityButton.frame = CGRect(x: 160, y: 62, width: 120, height: 28)
            self.locationButton.isEnabled = true
        case .locateFailure:
            self.locationButton .setTitle("定位失败,点击重试", for: .normal)
            self.locationButton .setImage(UIImage.init(named: "icon_loading"), for: UIControl.State.normal)
//            self.locationButton .mas_updateConstraints { (make) in
//                make?.width.mas_equalTo()(180)
//            }
//            self.currentCityButton .mas_updateConstraints { (make) in
//            make?.left.mas_equalTo()(self.locationButton.mas_right)?.offset()(20)
//            }
            self.locationButton.frame = CGRect(x: 20, y: 62, width: 180, height: 28)
            self.currentCityButton.frame = CGRect(x: 220, y: 62, width: 120, height: 28)
            self.locationButton.isEnabled = true
        case .locateComplete:
            self.locationButton .setTitle("", for: .normal)
            self.locationButton .setImage(UIImage.init(), for: UIControl.State.normal)
//            self.locationButton .mas_updateConstraints { (make) in
//                make?.width.mas_equalTo()(0)
//            }
//            self.currentCityButton .mas_updateConstraints { (make) in
//            make?.left.mas_equalTo()(self.locationButton.mas_right)?.offset()(0)
//            }
            self.locationButton.frame = CGRect(x: 20, y: 62, width: 0, height: 28)
            self.currentCityButton.frame = CGRect(x: 20, y: 62, width: 120, height: 28)
            self.locationButton.isEnabled = true
        default:
            self.locationButton .setTitle("未定位,点击定位", for: .normal)
            self.locationButton .setImage(UIImage.init(named: "icon_loading"), for: UIControl.State.normal)
//            self.locationButton .mas_updateConstraints { (make) in
//                make?.width.mas_equalTo()(166)
//            }
//            self.currentCityButton .mas_updateConstraints { (make) in
//            make?.left.mas_equalTo()(self.locationButton.mas_right)?.offset()(20)
//            }
            self.locationButton.frame = CGRect(x: 20, y: 62, width: 166, height: 28)
            self.currentCityButton.frame = CGRect(x: 206, y: 62, width: 120, height: 28)
            
            self.locationButton.isEnabled = true
        }
//        self.locationButton.letImageToRight()
    }
}

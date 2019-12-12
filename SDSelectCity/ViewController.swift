//
//  ViewController.swift
//  SDSelectCity
//
//  Created by slowdony on 2019/11/28.
//  Copyright © 2019 slowdony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self .setupUI()
        
        let manage = SDLocationManager .shared
        manage .startPositing(vc: self)
        manage.cityPositionBlock = {(msg:String ,error:String) -> Void in
            if (error.isEmpty){
               self .setLeftBtnTitle(title: msg)
            }else{
               self .setLeftBtnTitle(title: error)
            }
        }
        // Do any additional setup after loading the view.
    }

    lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: (44-30)/2, width: 50, height: 30)
        btn .setTitle("定位中", for: UIControl.State.normal)
        btn .setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn .addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func btnClick() {
        let vc =  SDCitySelectVC()
        vc.selectResultBlock = { (cityModel:SDCityModel) -> Void in
            self .setLeftBtnTitle(title: cityModel.name! as String)
        }
        navigationController! .pushViewController(vc, animated: true)
    }

}

extension ViewController {
    func setupUI() {
        title = "城市选择"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.leftBtn)
    }
    
    func setLeftBtnTitle(title:String) {
        self.leftBtn.setTitle(title, for: .normal)
    }
}

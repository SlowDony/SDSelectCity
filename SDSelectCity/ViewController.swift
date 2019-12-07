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
        title = "城市选择"
        self.view .addSubview(self.btn)
        // Do any additional setup after loading the view.
    }

    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
        btn .setTitle("按钮点击", for: UIControl.State.normal)
        btn .setTitleColor(UIColor.red, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn .addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func btnClick() {
        let vc =  SDCitySelectVC()
        
        navigationController! .pushViewController(vc, animated: true)
    }

}


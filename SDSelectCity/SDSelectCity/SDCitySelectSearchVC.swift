//
//  SDCitySelectSearchVC.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/14.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit

class SDCitySelectSearchVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    @objc var searchResultBlock:((SDCityModel)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self .setupNav()
        self .setupUI()
        // Do any additional setup after loading the view.
    }
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = UIColor.white
        
        let emptyText = UILabel()
        emptyText.frame = CGRect(x: 0, y: 207, width: kScreenW, height: 30)
        emptyText.backgroundColor = UIColor.clear
        emptyText.textColor = ColorHexA((0x2A2928), 0.1)
        emptyText.text = "没有找到相关城市"
        emptyText.textAlignment = NSTextAlignment.center
        emptyText.font = UIFont.systemFont(ofSize: 22)
        emptyText.numberOfLines = 1
        view .addSubview(emptyText)
        view.isHidden = true
        return view
    }()
    
    lazy var textFiled: UITextField = {
        let textFiled = UITextField(frame: CGRect(x: 30 , y: 8, width:  kScreenW-60 , height: 28))
        textFiled.delegate = self
        textFiled.backgroundColor = UIColor.clear
        textFiled.font =  UIFont .systemFont(ofSize: 14)
        textFiled.textColor = ColorHex(0x2A2928)
        textFiled.clearButtonMode = UITextField.ViewMode.whileEditing
        textFiled.keyboardType = UIKeyboardType.default
        textFiled.autocorrectionType = UITextAutocorrectionType.no
        textFiled.returnKeyType = UIReturnKeyType.search
        textFiled.backgroundColor = ColorHex(0xF1F1F1)
        textFiled.layer.cornerRadius = 28/2
        textFiled.layer.masksToBounds = true
        textFiled.tintColor = ColorHex(0xFF6532)
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor: ColorHex(0xAEAEAE),NSAttributedString.Key.font :  UIFont .systemFont(ofSize: 14)]
        textFiled.attributedPlaceholder = NSAttributedString(string: "请输入城市名称/拼音",attributes: placeholserAttributes)
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 42, height: 28)
        let leftImageView = UIImageView()
        leftImageView.frame = CGRect(x: 16, y: 7, width: 16, height: 16)
        leftImageView.image = UIImage.init(named: "nav_search")
        leftView .addSubview(leftImageView)
        
        textFiled.leftView = leftView
        textFiled.leftViewMode = UITextField.ViewMode.always
        textFiled .addTarget(self, action: #selector(textFiledChangeValue(textField:)), for: UIControl.Event.editingChanged)
        return textFiled
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavTopHeight, width: kScreenW, height: kScreenH-kNavTopHeight)
            , style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    lazy var dataArr: NSMutableArray = {
        let dataArr = NSMutableArray()
        return dataArr
    }()
    
    lazy var allArr: NSMutableArray = {
        let dataArr = NSMutableArray.init()
        return dataArr
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn .setTitle("取消", for: UIControl.State.normal)
        btn .setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn .addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        btn .setImage(UIImage.init(named: "nav_back"), for: UIControl.State.normal)
        btn .addTarget(self, action: #selector(popBtnClick), for: UIControl.Event.touchUpInside)
        return btn
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

// MARK: setup
extension SDCitySelectSearchVC{
    
    func setupNav(){
        self.navigationItem.titleView = self.textFiled

        let rightItem = UIBarButtonItem(customView: self.cancelBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(customView: self.leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem
        
    }
    
    func setupUI(){
        self.view .addSubview(self.emptyView)
        self.view .addSubview(self.tableView)
    }
    
    
    @objc func cancelBtnClick() {
        self.navigationController! .popViewController(animated: false)
    }
    
    @objc func popBtnClick() {
        self.navigationController! .popViewController(animated: false)
    }
}

// MARK: tableview代理
extension SDCitySelectSearchVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellId"
        let cell  = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        let cityModel = self.dataArr[indexPath.row] as! SDCityModel
        cell.textLabel?.text = cityModel.name as String?
        cell.textLabel?.font =  UIFont .systemFont(ofSize: 14)
        cell.textLabel?.textColor = ColorHex(0x2a2928)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let cityModel = self.dataArr[indexPath.row] as! SDCityModel
        
        
        if let searchResultBlock = searchResultBlock {
            searchResultBlock(cityModel)
        }
        self.navigationController? .popToRootViewController(animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textFiled .resignFirstResponder()
    }
}
// MARK: textFiledDelegae
extension SDCitySelectSearchVC{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        self .setnetWork(keyWork: textField.text!)
        return true
    }
}

extension SDCitySelectSearchVC{
    func setnetWork(keyWork:String){
        
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyWork)
        let reArray = self.allArr.filtered(using: predicate)
        
        self.dataArr = NSMutableArray(array: reArray)
        if(self.dataArr.count==0){
           self.emptyView.isHidden = false
        }else{
           self.emptyView.isHidden = true
        }
        self.tableView .reloadData()
    }
    
    @objc func textFiledChangeValue(textField:UITextField) {
          
          let lang = textFiled.textInputMode?.primaryLanguage
          if lang == "zh-Hans"
          {
              let selectRange = textFiled .markedTextRange
              
              if selectRange == nil || selectRange!.isEmpty
              {
                  self .setnetWork(keyWork: textField.text!)
              }else
              {
                  print("有高亮选择的字符串")
              }
          }else
          {
              self .setnetWork(keyWork: textField.text!)
          }
          
          
      }
}

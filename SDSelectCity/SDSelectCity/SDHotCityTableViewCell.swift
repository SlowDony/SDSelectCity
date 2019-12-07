//
//  SDHotCityTableViewCell.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/20.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit
@objc protocol BPHotCityCellDelegate {
    @objc optional
    func hotCityCellDidSelectItemAt(cityModel:SDCityModel)
}

class SDHotCityTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var cellDelegate :BPHotCityCellDelegate?
    
    lazy var dataArr: NSMutableArray = {
        let dataArr = NSMutableArray.init()
        return dataArr
    }()
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.itemSize = CGSize(width: (kScreenW-49-40-16)/3, height: 28)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 49)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: self.frame.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "SDCitySelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self .setUI()
    }
    
    
}

extension SDHotCityTableViewCell {
    func setUI(){
        self.addSubview(self.collectionView)
//        self.collectionView .mas_makeConstraints { (make) in
//            make?.edges.mas_equalTo()(self)
//        }
        self .layoutIfNeeded()
    }
    
    func setCellData(data:NSMutableArray) {
        self.dataArr = data
        self.collectionView .reloadData()
    }
    
    override func layoutSubviews() {
        self.collectionView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.bounds.height)
    }
}

// MARK: class func
extension SDHotCityTableViewCell {
    
    class func B_cellWithTableView(_ tableView: UITableView) -> SDHotCityTableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "HotCityTableViewCellID")
        if cell == nil {
            cell = SDHotCityTableViewCell.init(style: .default, reuseIdentifier: "HotCityTableViewCellID")
        }
        return cell as! SDHotCityTableViewCell
    }
    class func cellHeight(data:NSMutableArray) -> CGFloat {
        let height = (data.count+2)/3*(28+12)+12
        return CGFloat(height)
    }
}


// MARK: UICollectionViewDelegate
extension SDHotCityTableViewCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SDCitySelectCollectionViewCell
        let cityModel = self.dataArr[indexPath.row] as! SDCityModel
        cell.cityButton .setTitle(cityModel.name as String?, for: .normal)
        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cityModel = self.dataArr[indexPath.row] as! SDCityModel
        
        cellDelegate?.hotCityCellDidSelectItemAt?(cityModel: cityModel)
    }
}

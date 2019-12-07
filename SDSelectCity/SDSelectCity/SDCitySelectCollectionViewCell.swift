//
//  SDCitySelectCollectionViewCell.swift
//  BotuPanoram
//
//  Created by slowdony on 2019/11/14.
//  Copyright © 2019 Bicon. All rights reserved.
//

import UIKit

class SDCitySelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cityButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cityButton.layer.borderWidth = 0.5
        self.cityButton.layer.borderColor = ColorHex(0xD8D8D8).cgColor
        self.cityButton.layer.cornerRadius = 2
        self.cityButton.layer.masksToBounds = true
        self.cityButton.isEnabled = false
    }

}

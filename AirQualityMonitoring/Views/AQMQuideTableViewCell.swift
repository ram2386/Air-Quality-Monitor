//
//  AQMQuideTableViewCell.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

import UIKit

//** AQMQuideTableViewCell view class does is :**
//1. In AQMQuideVC screen, UITableView use this cell.
//2. Represent the Air Quality Monitor Index information.
//3. AQMQuideModel has changes then it reflected in UI

class AQMQuideTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblIndex: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    //AQMQuideModel use didSet() for cell's UI representation
    var guideData: AQMQuideModel? {
        didSet {
            //Has data to represent the Air Quality Monitor Index information
            guard let guideData = guideData else { return }
            //Set index
            lblIndex.text = guideData.index
            //Set category
            lblCategory.text = guideData.category.rawValue.capitalized
            //Set background color
            self.contentView.backgroundColor = guideData.color
        }
    }
}

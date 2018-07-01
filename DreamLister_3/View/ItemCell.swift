//
//  ItemCell.swift
//  DreamLister_3
//
//  Created by vriz on 2018. 7. 1..
//  Copyright © 2018년 vriz. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    
    func configureCell(item: Item){
        thumbImg.image = item.toImage?.image as? UIImage
        titleLbl.text = item.title
        priceLbl.text = "$\(item.price)"
        detailsLbl.text = item.details
    }
}

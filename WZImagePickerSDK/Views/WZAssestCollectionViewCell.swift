//
//  WZAssestCollectionViewCell.swift
//  imagePickerWz
//
//  Created by Adeel on 19/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit

class WZAssestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var selectedIndicator : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        selectedIndicator.layer.cornerRadius = selectedIndicator.frame.size.width / 2
        selectedIndicator.layer.borderWidth  = 1
        selectedIndicator.layer.borderColor  = UIColor.white.cgColor
    }

    func populateCellsData (_ image : UIImage?)
    {
        //let image       = getAssetThumbnail(asset: assest)
        if let assestImage = image
        {
            imageView.image = assestImage
        }
        else
        {
            imageView.image = CustomMethods.placeholderImageWithSize(imageView.bounds.size)
        }
    }
}

//
//  WZAlbumCollectionViewCell.swift
//  imagePickerWz
//
//  Created by Adeel on 19/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

class WZAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageview1: UIImageView!
    @IBOutlet var imageview2: UIImageView!
    @IBOutlet var imageview3: UIImageView!
    @IBOutlet var albumsTitle: UILabel!
    @IBOutlet var numberOfPhotos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setBorderWidth (_ borderWidth : CGFloat)
    {
        imageview1.layer.borderColor = UIColor.white.cgColor
        imageview2.layer.borderColor = UIColor.white.cgColor
        imageview3.layer.borderColor = UIColor.white.cgColor
        
        imageview1.layer.borderWidth = borderWidth
        imageview2.layer.borderWidth = borderWidth
        imageview3.layer.borderWidth = borderWidth
    }
    
    
    func setAssestInCollectionview (_ assest :  PHAssetCollection, _ indexPath : IndexPath, _ image : UIImage?)
        {
            self.tag = indexPath.item
            
            //let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
            let fetchOptions = PHFetchOptions()

            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            let fetchAssetsResult = PHAsset.fetchAssets(in: assest, options: fetchOptions)
            imageview1.isHidden = true;
            imageview3.isHidden = true;
            
            if let imageAlbum = image
            {
                imageview2.image = imageAlbum
            }
            else
            {
                let placeHoderImage = CustomMethods.placeholderImageWithSize(imageview1.frame.size)
                imageview2.image = placeHoderImage
            }

            
            if fetchAssetsResult.count == 0
            {
                imageview1.isHidden = true;
                imageview3.isHidden = true;
                
                let placeHoderImage = CustomMethods.placeholderImageWithSize(imageview1.frame.size)
                imageview3.image = placeHoderImage
                imageview2.image = placeHoderImage
                imageview1.image = placeHoderImage
            }
            
            albumsTitle.text = assest.localizedTitle
            numberOfPhotos.text = "\(fetchAssetsResult.count)"
        }
}

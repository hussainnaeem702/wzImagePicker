//
//  AlbumsCollectionViewCell.swift
//  WzPicker
//
//  Created by Adeel on 10/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos
//import SDWebImage

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageview1: UIImageView!
    @IBOutlet var imageview2: UIImageView!
    @IBOutlet var imageview3: UIImageView!
    @IBOutlet var albumsTitle: UILabel!
    @IBOutlet var numberOfPhotos: UILabel!
    
    
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
        
//        let imageManager     = PHImageManager()
        
//        if fetchAssetsResult.count >= 3
//        {
//            imageview3.isHidden = false;
//
//            imageManager.requestImage(for: fetchAssetsResult[fetchAssetsResult.count - 3], targetSize: imageview3.frame.size, contentMode: .aspectFit, options: nil) { (image, dict) in
//
//                if (self.tag ==  indexPath.item)
//                {
//                    self.imageview3.image = image
//                }
//            }
//        }
//        else
//        {
//            imageview3.isHidden = true;
//        }
//
//
//        if fetchAssetsResult.count >= 2
//        {
//            imageview2.isHidden = false;
//
//            imageManager.requestImage(for: fetchAssetsResult[fetchAssetsResult.count - 2], targetSize: imageview2.frame.size, contentMode: .aspectFit, options: nil) { (image, dict) in
//
//                if (self.tag ==  indexPath.item)
//                {
//                    self.imageview2.image = image
//                }
//            }
//        }
//        else
//        {
//            imageview2.isHidden = true;
//        }
//
//
//        if fetchAssetsResult.count >= 1
//        {
//            imageview1.isHidden = false;
//
//            imageManager.requestImage(for: fetchAssetsResult[fetchAssetsResult.count - 1], targetSize: imageview1.frame.size, contentMode: .aspectFit, options: nil) { (image, dict) in
//
//                if (self.tag ==  indexPath.item)
//                {
//                    self.imageview1.image = image
//                }
//            }
//        }
//        else
//        {
//            imageview1.isHidden = true;
//        }
        
        
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
    
    
    
//    func populateCellsDataForFacebookSDk (_ albumsData : FacebookAlbums)
//    {
//        imageview2.isHidden = true;
//        imageview3.isHidden = true;
//
//        let placeHoderImage = CustomMethods.placeholderImageWithSize(imageview1.frame.size)
//        imageview3.image = placeHoderImage
//        imageview2.image = placeHoderImage
//        imageview1.image = placeHoderImage
//
//        albumsTitle.text    = albumsData.name
//        numberOfPhotos.text = albumsData.createTime
//        imageview1.sd_setImage(with: URL(string: albumsData.imageUrl), placeholderImage: placeHoderImage)
//    }
    
}




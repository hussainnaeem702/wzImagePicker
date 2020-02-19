//
//  WZAlbumsViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 19/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

public class WZAlbumsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var assestsCollection               = [PHAssetCollection]()
    var allPhotos                       : PHFetchResult<PHAsset>? = nil
    var imagesAndAssestForAllAlbums     = [String : UIImage?]()
    var imagesAndAssestForAllPhotots    = [String : UIImage]()
    var selectedIndex                   = [Int : Bool]()
    
    /**************************************************************************************/
    // MARK: -  --------------------------- Outlets ------------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionViewAlbums : UICollectionView!
    @IBOutlet weak var collectionviewPictures: UICollectionView!
    @IBOutlet weak var picturesView: UIView!
    @IBOutlet weak var albumsView: UIView!
    @IBOutlet weak var albumsButton: UIButton!
    @IBOutlet weak var picturesButton: UIButton!
    @IBOutlet weak var leadingConstOfHighLightedView: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    /**************************************************************************************/
    // MARK: -  -------------------------- View Controllers life Cycle --------------------
    /**************************************************************************************/
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        
        /// CODE FOR ALBUMS TAB
        
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let userAlbum  = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        let fetchResult = [smartAlbum] // , userAlbum
        for result in fetchResult
        {
            result.enumerateObjects({(collection, index, object) in
                let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
                print(photoInAlbum.count)
                print(collection.localizedTitle ?? "")
            
                self.assestsCollection.append(collection)
                
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
                let fetchAssetsResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                let imageManager     = PHImageManager()
                if (fetchAssetsResult.count == 0)
                {
                    self.imagesAndAssestForAllAlbums[collection.localIdentifier] = nil
                }
                else
                {
                    imageManager.requestImage(for: fetchAssetsResult[fetchAssetsResult.count - 1], targetSize: CGSize(width: 100,height: 100), contentMode: .aspectFill, options: nil) { (image, dict) in
                        
                        self.imagesAndAssestForAllAlbums[collection.localIdentifier] = image
                    }
                }
            })
        }
        
        /// CODE FOR PICTURES TAB
        
        activityIndicator.startAnimating()
        picturesView.isHidden = true
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                if let photos = self.allPhotos
                {
                    for number in 0..<photos.count
                    {
                        if let val = self.selectedIndex[number]
                        {
                            self.selectedIndex[number] = val
                        }
                        else
                        {
                            self.selectedIndex[number] = false
                        }
                        
                        let assest = photos[number]
                        let image  = CustomMethods.getAssetThumbnail(asset: assest)
                        self.imagesAndAssestForAllPhotots[assest.localIdentifier] = image
                    }
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionviewPictures.reloadData()
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            
            }
        }
        
        
        
        collectionviewPictures.register(UINib(nibName: "WZAssestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WZAssestCollectionViewCell")
        collectionViewAlbums.register(UINib(nibName: "WZAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WZAlbumCollectionViewCell")
    }

    /**************************************************************************************/
    // MARK: -  ---------------- Collection View Delegate and DataSource ---------------
    /**************************************************************************************/
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionViewAlbums
        {
            return assestsCollection.count
        }
        else
        {
            return allPhotos?.count ?? 0
        }
    }
    
    /**************************************************************************************/
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionViewAlbums
        {
            let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAlbumCollectionViewCell", for: indexPath) as! WZAlbumCollectionViewCell
            let assest  = assestsCollection[indexPath.item]
            cell.setBorderWidth(1 / UIScreen.main.scale)
            
            cell.setAssestInCollectionview(assest, indexPath, imagesAndAssestForAllAlbums[assest.localIdentifier] ?? nil)
            return cell
        }
        else
        {
            let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAssestCollectionViewCell", for: indexPath) as! WZAssestCollectionViewCell
            let assest              = allPhotos?[indexPath.item]
            let assestImage         = imagesAndAssestForAllPhotots[assest?.localIdentifier ?? ""]
            if (selectedIndex[indexPath.item] == true)
            {
                cell.selectedIndicator.backgroundColor = .blue
            }
            else
            {
                cell.selectedIndicator.backgroundColor = UIColor.white
            }
            
            cell.populateCellsData(assestImage ?? nil)
            return cell
        }
    }
    
    /**************************************************************************************/
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell()
    }

    /**************************************************************************************/
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionViewAlbums
        {
            let assestVc                = WZAssestViewController() // self.storyboard?.instantiateViewController(withIdentifier: "WZAssestViewController") as!
            assestVc.albumTitle         = assestsCollection[indexPath.item].localizedTitle ?? ""
            assestVc.phassetCollection  = assestsCollection[indexPath.item]
            self.present(assestVc, animated: true, completion: nil)//navigationController?.pushViewController(assestVc, animated: true)
        }
        else
        {
            if selectedIndex[indexPath.item] == true
            {
                selectedIndex[indexPath.item] = false
            }
            else
            {
                selectedIndex[indexPath.item] = true
            }
            
            collectionviewPictures.reloadData()
        }
    }

    /**************************************************************************************/
    // MARK: -  ---------------- Actions ---------------
    /**************************************************************************************/
    
    @IBAction func albumsButtonTapped(_ sender: Any)
    {
        picturesView.isHidden = true
        albumsView.isHidden   = false
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstOfHighLightedView.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func picturesButtonTapped(_ sender: Any)
    {
        picturesView.isHidden = false
        albumsView.isHidden   = true
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstOfHighLightedView.constant = self.albumsButton.bounds.width
            self.view.layoutIfNeeded()
        }
    }

}

//
//  WZAssestViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 19/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

class WZAssestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var phassetCollection : PHAssetCollection?      = nil
    var resultCollection  : PHFetchResult<PHAsset>? = nil
    var albumTitle        : String?                 = nil
    var imagesAndAssestForAllPhotots                = [String : UIImage?]()
    var selectedIndex                               = [Int : Bool]()
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Outlets -----------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionviewForAllImages : UICollectionView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    /**************************************************************************************/
    // MARK: -  ------------------------ ViewControllers lifeCycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchOptions        = PHFetchOptions()
        fetchOptions.predicate  = NSPredicate(format: "mediaType == 1") // NSPredicate(format: "title = %@", albumTitle) //
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        resultCollection        = PHAsset.fetchAssets(in: phassetCollection!, options: fetchOptions)
        
        activityIndicator.startAnimating()
        if let photos = resultCollection
        {
            if photos.count > 0
            {
                for number in 0..<photos.count
                {
                    /// code for selected items
                    
                    if let val = self.selectedIndex[number]
                    {
                        self.selectedIndex[number] = val
                    }
                    else
                    {
                        self.selectedIndex[number] = false
                    }
                         
                    let assest = photos[number]
                    self.imagesAndAssestForAllPhotots[assest.localIdentifier] = CustomMethods.getAssetThumbnail(asset: assest)
                }
                self.activityIndicator.stopAnimating()
            }
        }
        
        print(resultCollection)
        
        collectionviewForAllImages.register(UINib(nibName: "WZAssestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WZAssestCollectionViewCell")
    }

    /**************************************************************************************/
    // MARK: -  ------------- CollectionView Delegate and DataSource -----------------
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return resultCollection?.count ?? 0
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAssestCollectionViewCell", for: indexPath) as! WZAssestCollectionViewCell
        let assest              = resultCollection?[indexPath.item]
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
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell()
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex[indexPath.item] == true
        {
            selectedIndex[indexPath.item] = false
        }
        else
        {
            selectedIndex[indexPath.item] = true
        }
        collectionviewForAllImages.reloadData()
    }

}

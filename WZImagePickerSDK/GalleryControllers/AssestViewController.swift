//
//  AssestViewController.swift
//  WzPicker
//
//  Created by Adeel on 10/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

class AssestViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    var phassetCollection : PHAssetCollection?      = nil
    var resultCollection  : PHFetchResult<PHAsset>? = nil
    var albumTitle        : String?                 = nil
    var imagesAndAssestForAllPhotots                = [String : UIImage?]()
    var selectedIndex                               = [Int : Bool]()
    
    @IBOutlet weak var collectionviewForAllImages : UICollectionView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = albumTitle
        navigationController?.navigationBar.barTintColor        = UIColor(red: 41/255, green: 40/255, blue: 56/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)]
        tabBarController?.tabBar.barTintColor                   = UIColor(red: 41/255, green: 40/255, blue: 56/255, alpha: 1)
    }
   

    // MARK: - CollectionView delegate and datasource

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return resultCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "AssestCollectionViewCell", for: indexPath) as! AssestCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell()
    }
    
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

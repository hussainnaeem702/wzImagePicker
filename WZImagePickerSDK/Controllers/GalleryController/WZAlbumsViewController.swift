//
//  WZAlbumsViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 19/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

protocol WzSelectedPictureDelegate {
    func didFinishSelection(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?)
    func didCancel()
}

class WZAlbumsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WzSelectedSingleAlbumsPictureDelegate {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var assestsCollection               = [PHAssetCollection]()
    var allPhotos                       : PHFetchResult<PHAsset>? = nil
    var delegate                        : WzSelectedPictureDelegate?
    var selectedImagesIndex             = [Int]()
    
    /// declarations for customisation of UI
    var backgroundColor                 : UIColor?              = nil
    var topSectionColor                 : UIColor?              = nil
    var highLightedIndicatorColor       : UIColor?              = nil
    var topButtonsTextColor             : UIColor?              = nil
    var albumsCellBackgoundColor        : UIColor?              = nil
    var albumsImageBorderColor          : UIColor?              = nil
    var albumsTextColor                 : UIColor?              = nil
    var selectedImageColor              : UIColor?              = nil
    var topButtonsSepratorviewBGColor   : UIColor?              = nil
    var imagesBorderWidth               : CGFloat?              = nil
    var albumsBorderCorners             : CGFloat?              = nil
    var imagesCorners                   : CGFloat?              = nil
    var selectedType                    : SelectedMediaType?    = nil
    var selectionType                   : SelectionType?        = SelectionType.multipleSelection
    
    /**************************************************************************************/
    // MARK: -  --------------------------- Outlets ------------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionViewAlbums         : UICollectionView!
    @IBOutlet weak var collectionviewPictures       : UICollectionView!
    @IBOutlet weak var picturesView                 : UIView!
    @IBOutlet weak var albumsView                   : UIView!
    @IBOutlet weak var albumsButton                 : UIButton!
    @IBOutlet weak var picturesButton               : UIButton!
    @IBOutlet weak var leadingConstOfHighLightedView: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator            : UIActivityIndicatorView!
    @IBOutlet weak var backgorundView               : UIView!
    @IBOutlet weak var topSectionView               : UIView!
    @IBOutlet weak var highLightedIndicatorView     : UIView!
    @IBOutlet weak var doneBarButton                : UIBarButtonItem!
    @IBOutlet weak var cancelBarButton              : UIBarButtonItem!
    @IBOutlet weak var topButtonsSepretorView       : UIView!
    
    /**************************************************************************************/
    // MARK: -  -------------------------- View Controllers life Cycle --------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// CODE FOR ALBUMS TAB
        /**************************************************************************************/
        
        
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        //let userAlbum  = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)

        let fetchResult = [smartAlbum] // , userAlbum
        for result in fetchResult
        {
            result.enumerateObjects({(collection, index, object) in
                
                let fetchOptions                = PHFetchOptions()
                fetchOptions.sortDescriptors    = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                if (self.selectedType != nil)
                {
                    fetchOptions.predicate = NSPredicate(format: "mediaType == \(self.selectedType?.rawValue ?? 1)")
                }
                else
                {
                    fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                }
                
                let photoInAlbum                = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                
                if photoInAlbum.count != 0
                {
                    self.assestsCollection.append(collection)
                }
                
            })
        }
        
        /// CODE FOR PICTURES TAB
        /**************************************************************************************/
        
//        activityIndicator.startAnimating()
        picturesView.isHidden   = true
        doneBarButton.isEnabled =  false
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions             = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                if (self.selectedType != nil)
                {
                    fetchOptions.predicate = NSPredicate(format: "mediaType == \(self.selectedType?.rawValue ?? 1)")
                }
                else
                {
                    fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                }
                
                if (self.selectedType != nil)
                {
                    if self.selectedType?.rawValue == 1
                    {
                        self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                    }
                    else
                    {
                        self.allPhotos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                    }
                }
                else
                {
                    self.allPhotos = PHAsset.fetchAssets(with: fetchOptions)
                }
                
//                if let photos = self.allPhotos
//                {
//                    if photos.count > self.pagePerMedia
//                    {
//                        self.totalCountReq = photos.count / self.pagePerMedia
//                    }
//                    else
//                    {
//                        self.totalCountReq = 0
//                    }
//                    self.getMediaInChunks()
//                }
//                    for number in 0..<photos.count
//                    {
//                        if let val = self.selectedIndex[number]
//                        {
//                            self.selectedIndex[number] = val
//                        }
//                        else
//                        {
//                            self.selectedIndex[number] = false
//                        }
//
//                        let assest = photos[number]
//                        let image  = CustomMethods.getAssetThumbnail(asset: assest)
//                        self.imagesAndAssestForAllPhotots[assest.localIdentifier] = image
//                    }
//                }
//
                DispatchQueue.main.async {
                    self.collectionviewPictures.reloadData()
                }
                
            case .denied, .restricted:
                print("Not allowed")
                break;
            case .notDetermined:
                print("Not determined yet")
                break;
            }
        }
    
    }
    
    /**************************************************************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// customise UI changes according to set
        /**************************************************************************************/
        
        if (backgroundColor != nil)
        {
            backgorundView.backgroundColor = backgroundColor
        }
        
        if (topSectionColor != nil)
        {
            topSectionView.backgroundColor = topSectionColor
        }
        
        if (highLightedIndicatorColor != nil)
        {
            highLightedIndicatorView.backgroundColor = highLightedIndicatorColor
        }
        
        if (topButtonsTextColor != nil)
        {
            albumsButton.setTitleColor(topButtonsTextColor, for: .normal)
            picturesButton.setTitleColor(topButtonsTextColor, for: .normal)
        }
        
        if (topButtonsSepratorviewBGColor != nil)
        {
            topButtonsSepretorView.backgroundColor = topButtonsSepratorviewBGColor
        }
    }

    /**************************************************************************************/
    // MARK: -  ---------------- Collection View Delegate and DataSource ---------------
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        /// collection view albums
        /**************************************************************************************/
        
        if collectionView == collectionViewAlbums
        {
            let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAlbumCollectionViewCell", for: indexPath) as! WZAlbumCollectionViewCell
            let assest  = assestsCollection[indexPath.item]
            cell.setBorderWidth(1 / UIScreen.main.scale)
            
            cell.setAssestInCollectionview(assest, indexPath, self.selectedType?.rawValue )
            
            if (albumsCellBackgoundColor != nil)
            {
                cell.mainBackgroundView.backgroundColor = albumsCellBackgoundColor
            }
            
            if (albumsTextColor != nil)
            {
                cell.albumsTitle.textColor = albumsTextColor
                cell.numberOfPhotos.textColor = albumsTextColor
            }
            
            if (albumsBorderCorners != nil)
            {
                cell.mainBackgroundView.layer.cornerRadius   = albumsBorderCorners!
                
            }
            
            /// for images handling
            if (albumsImageBorderColor != nil)
            {
                cell.albumImageBackground.backgroundColor = UIColor.clear
                cell.imageview2.layer.borderColor   = albumsImageBorderColor?.cgColor
            }
            
            if (imagesBorderWidth != nil)
            {
                cell.imageview2.layer.borderWidth   = imagesBorderWidth!
                //cell.albumImageBackground.layer.borderWidth = imagesBorderWidth!
            }
            
            if (imagesCorners != nil)
            {
                //cell.albumImageBackground.layer.cornerRadius = albumsBorderCorners!
                //cell.albumImageBackground.layer.borderWidth = albumsBorderCorners
                cell.imageview2.layer.cornerRadius   = imagesCorners!
            }
            
            return cell
        }
        else
        {
            /// collection view Images
            /**************************************************************************************/
            
            let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAssestCollectionViewCell", for: indexPath) as! WZAssestCollectionViewCell
            let assest              = allPhotos?[indexPath.item]
            
            if selectedImagesIndex.contains(indexPath.item)
            {
                var selectColor = UIColor()
                if selectedImageColor != nil
                {
                    selectColor = selectedImageColor!
                }
                else
                {
                    selectColor = .blue
                }
                cell.selectedIndicator.backgroundColor = selectColor
            }
            else
            {
                cell.selectedIndicator.backgroundColor = UIColor.white
            }
            
            if (imagesCorners != nil)
            {
                cell.imageView.layer.cornerRadius   = imagesCorners!
            }
            
            cell.populateCellDataWithAssets(assest)
            
            return cell
        }
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell(collectionView.frame.width)
    }

    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionViewAlbums
        {
            
            let storyboard  = UIStoryboard(name: "WzPicker", bundle: Bundle(for: type(of: self)))
            let assestVc    = storyboard.instantiateViewController(withIdentifier: "WZAssestViewController") as! WZAssestViewController
            
            assestVc.albumTitle         = assestsCollection[indexPath.item].localizedTitle ?? ""
            assestVc.phassetCollection  = assestsCollection[indexPath.item]
            assestVc.backgroundColor    = backgroundColor
            assestVc.imagesCorners      = imagesCorners
            assestVc.selectedImageColor = selectedImageColor
            assestVc.selectedMediaType  = self.selectedType?.rawValue
            assestVc.delegate           = self
            assestVc.selectionType      = selectionType
            
            self.present(assestVc, animated: true, completion: nil)
        }
        else
        {
            if selectionType == SelectionType.singleSelection
            {
                selectedImagesIndex = [indexPath.item]
            }
            else
            {
                if selectedImagesIndex.contains(indexPath.item)
                {
                    selectedImagesIndex.removeAll{$0 == indexPath.item}
                }
                else
                {
                    selectedImagesIndex.append(indexPath.item)
                }
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
        doneBarButton.isEnabled =  false
        UIView.animate(withDuration: 0.3) {
            self.leadingConstOfHighLightedView.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    /**************************************************************************************/
    
    @IBAction func picturesButtonTapped(_ sender: Any)
    {
        picturesView.isHidden = false
        albumsView.isHidden   = true
        doneBarButton.isEnabled =  true
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstOfHighLightedView.constant = self.albumsButton.bounds.width
            self.view.layoutIfNeeded()
        }
    }

    /**************************************************************************************/
    
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem)
    {
        delegate?.didCancel()
        dismiss(animated: true, completion: nil)
    }
    
    /**************************************************************************************/
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem)
    {
        var imageToTransfer = [PHAsset]()
        for index in selectedImagesIndex
        {
            if let assest                      = allPhotos?[index]
            {
                imageToTransfer.append(assest)
            }
        }
        
        if imageToTransfer.count > 0
        {
            delegate?.didFinishSelection(imageToTransfer, nil)
        }
    }
    
    /**************************************************************************************/
    // MARK: -  ---------------- Custom Delegate Methods ---------------
    /**************************************************************************************/
    
    func didFinishSelectionOfAlbumsPicture(_ mediaAssest: [PHAsset]?, _ images: [UIImage]?) {
        delegate?.didFinishSelection(mediaAssest, nil)
    }
    
    /****************************************************************/
    
    func didCancelForSelection() {
        delegate?.didCancel()
    }
    
}

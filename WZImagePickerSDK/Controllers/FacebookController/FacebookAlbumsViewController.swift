//
//  FacebookAlbumsViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 30/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos
import FBSDKCoreKit
import FBSDKLoginKit

protocol WzPassMediaFromFacebookDelegate {
    func didFinishSelectionMediaFromFacebook(_ selectedMeidaURLs : [URL])
    func didCancelFacebook()
}

class FacebookAlbumsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WzSelectedMediaFromFacebookDelegate {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var facebookAlbums                  = [FacebookAlbums]()
    let loginManager                    = LoginManager()
    var loopCounterForGetImagesAndData  = 0
    var delegate                        : WzPassMediaFromFacebookDelegate?
    
//    /// declarations for customisation of UI
//    var backgroundColor                 : UIColor?              = nil
//    var activityIndicatorViewColor      : UIColor?              = nil
//    var topSectionColor                 : UIColor?              = nil
//    var highLightedIndicatorColor       : UIColor?              = nil
//    var topButtonsTextColor             : UIColor?              = nil
//    var albumsCellBackgoundColor        : UIColor?              = nil
//    var albumsImageBorderColor          : UIColor?              = nil
//    var albumsTextColor                 : UIColor?              = nil
//    var selectedImageColor              : UIColor?              = nil
//    //var topButtonsSepratorviewBGColor   : UIColor?              = nil
//    var imagesBorderWidth               : CGFloat?              = nil
//    var albumsBorderCorners             : CGFloat?              = nil
//    var imagesCorners                   : CGFloat?              = nil
//    var selectedType                    : SelectedMediaType?    = nil
//    var selectionType                   : SelectionType?        = SelectionType.multipleSelection
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Outlets  -----------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionviewAlbums : UICollectionView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!
    @IBOutlet weak var backgroundViewColor  : UIView!
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controllers lifeCycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        loopCounterForGetImagesAndData = 0
        
        loginManager.logIn(permissions: ["public_profile", "user_photos", "email", "user_friends", "user_videos"], from: self) { (result, error) in
            if error != nil
            {
                //print(error?.localizedDescription ?? "")
            }
            else
            {
                self.getDataOfFacebookProfile()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// customised UI
        
        if CommonVariables.backgroundColor != nil
        {
            backgroundViewColor.backgroundColor = CommonVariables.backgroundColor
        }
        if CommonVariables.activityIndicatorBgColor != nil
        {
            activityIndicator.color   = CommonVariables.activityIndicatorBgColor
        }
    }
    /**************************************************************************************/
    // MARK: -  ------------------------ Collectionview Delegate and Datasource -----------------------------
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return facebookAlbums.count
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAlbumCollectionViewCell", for: indexPath) as! WZAlbumCollectionViewCell
        cell.setBorderWidth(1 / UIScreen.main.scale)
        
        let fbAlbum = facebookAlbums[indexPath.item]
        
        cell.populateCellsDataForFacebookSDk(fbAlbum)
        
        if (CommonVariables.albumsCellBackgoundColor != nil)
        {
            cell.mainBackgroundView.backgroundColor = CommonVariables.albumsCellBackgoundColor
        }
        
        if (CommonVariables.albumsTextColor != nil)
        {
            cell.albumsTitle.textColor = CommonVariables.albumsTextColor
            cell.numberOfPhotos.textColor = CommonVariables.albumsTextColor
        }
        
        if (CommonVariables.albumsBorderCorners != nil)
        {
            cell.mainBackgroundView.layer.cornerRadius   = CommonVariables.albumsBorderCorners!
            
        }
        
        /// for images handling
        if (CommonVariables.albumsImageBorderColor != nil)
        {
            cell.albumImageBackground.backgroundColor = UIColor.clear
            cell.imageview2.layer.borderColor   = CommonVariables.albumsImageBorderColor?.cgColor
        }
        
        if (CommonVariables.imagesBorderWidth != nil)
        {
            cell.imageview2.layer.borderWidth   = CommonVariables.imagesBorderWidth!
            //cell.albumImageBackground.layer.borderWidth = imagesBorderWidth!
        }
        
        if (CommonVariables.imagesCorners != nil)
        {
            //cell.albumImageBackground.layer.cornerRadius = albumsBorderCorners!
            //cell.albumImageBackground.layer.borderWidth = albumsBorderCorners
            cell.imageview2.layer.cornerRadius   = CommonVariables.imagesCorners!
        }
        return cell
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell(collectionView.frame.width)
    }

    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let album      = facebookAlbums[indexPath.item]
        
        let assestVc                    = self.storyboard?.instantiateViewController(withIdentifier: "FacebookAlbumImagesViewController") as! FacebookAlbumImagesViewController
        assestVc.facebookAlbums         = album
//        assestVc.albumTitle         = assestsCollection[indexPath.item].localizedTitle ?? ""
//        assestVc.phassetCollection  = assestsCollection[indexPath.item]
//        assestVc.backgroundColor        = backgroundColor
//        assestVc.actvityIndicatorColor  = activityIndicatorViewColor
//        assestVc.imagesCorners          = imagesCorners
//        assestVc.selectedImageColor     = selectedImageColor
//        assestVc.selectedMediaType      = self.selectedType?.rawValue
        assestVc.delegate               = self
//        assestVc.selectionType          = selectionType
        self.present(assestVc, animated: true, completion: nil)
    }

    /**************************************************************************************/
    // MARK: -  ------------------------ Custom Methods -----------------------------
    /**************************************************************************************/
    
    func getDataOfFacebookProfile()
    {
        activityIndicator.startAnimating()
        let grapthReq = GraphRequest.init(graphPath: "me/albums", httpMethod: .get)
        grapthReq.start { (connection, result, error) in
            if (error == nil)
            {
               // print(result ?? "")
                if let responseResult = result as? [String : Any]
                {
                    if let data = CustomMethods.getDictArrayValue(keyString: "data", dictionary: responseResult)
                    {
                        //print(data)
                        
                        if self.loopCounterForGetImagesAndData < data.count
                        {
                            let response        = data[self.loopCounterForGetImagesAndData]
                            let fbAlbum         = FacebookAlbums()
                            
                            fbAlbum.createTime = CustomMethods.getStringValue(keyString: "created_time", dictionary: response)
                            fbAlbum.album_id    = CustomMethods.getStringValue(keyString: "id", dictionary: response)
                            fbAlbum.name       = CustomMethods.getStringValue(keyString: "name", dictionary: response)
                            
                            let coverImageString = "/\(fbAlbum.album_id)?fields=picture"
                            
                            let imageReq = GraphRequest.init(graphPath: coverImageString, httpMethod: .get)
                            imageReq.start { (conn, result, error) in
                                
                                if (error == nil)
                                {
                                    //print(result ?? "")
                                    if let responseResult = result as? [String : Any]
                                    {
                                        if let picData = CustomMethods.getDictionaryValue(keyString: "picture", dictionary: responseResult)
                                        {
                                           // print(picData)
                                            if let imageUrlData = CustomMethods.getDictionaryValue(keyString: "data", dictionary: picData)
                                            {
                                               // print(imageUrlData )
                                                let imageUrl        = CustomMethods.getStringValue(keyString: "url", dictionary: imageUrlData)
                                                fbAlbum.imageUrl    = imageUrl
                                            }
                                        }
                                    }
                                }
                                self.loopCounterForGetImagesAndData += 1
                                self.facebookAlbums.append(fbAlbum)
                                self.getDataOfFacebookProfile()
                            }
                        }
                        else
                        {
                            self.collectionviewAlbums.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
            else
            {
               // print(error ?? "")
            }
        }
    }
    
    func didFinishMediaPickingFromFacebook(_ mediaURL: [URL]) {
        delegate?.didFinishSelectionMediaFromFacebook(mediaURL)
        dismiss(animated: true, completion: nil)
    }
    func didCancelPickingMediaFromFacebook() {
        delegate?.didCancelFacebook()
        dismiss(animated: true, completion: nil)
    }
    
}

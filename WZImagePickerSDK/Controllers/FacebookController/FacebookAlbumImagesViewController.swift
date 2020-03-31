//
//  FacebookAlbumImagesViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 30/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SDWebImage
import Alamofire
import Photos

protocol WzSelectedMediaFromFacebookDelegate {
    func didFinishMediaPickingFromFacebook(_ mediaURL : [URL])
    func didCancelPickingMediaFromFacebook()
}

class FacebookAlbumImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var facebookAlbums                  = FacebookAlbums()
    var loopCounterForGetImagesAndData  = 0
    var facebookAlbumsData              = FacebookAlbumsData()
    var selectedImagesIndex             = [Int]()//[Int : Bool]()
    var delegate                        : WzSelectedMediaFromFacebookDelegate?
    
//    var backgroundColor             : UIColor?                = nil
//    var actvityIndicatorColor       : UIColor?                = nil
//    var imagesCorners               : CGFloat?                = nil
//    var selectedImageColor          : UIColor?                = nil
//    var selectedMediaType           : Int?                    = nil
//    var selectionType               : SelectionType?
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Outlets  -----------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionviewImages : UICollectionView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!
    @IBOutlet weak var backgroundViewColor  : UIView!
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controllers life cycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loopCounterForGetImagesAndData = 0
        getDataOfCurrentPage(nil)
        
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
    // MARK: -  ------------------------ Collection view delegate and datasource -----------------------------
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return facebookAlbumsData.imagesData.count
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell                = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAssestCollectionViewCell", for: indexPath) as! WZAssestCollectionViewCell
        let imagesArray     = facebookAlbumsData.imagesData[indexPath.item].imagesData.images
        
        let imageUrl        = imagesArray[imagesArray.count - 2].source //facebookAlbumsData.imagesData[indexPath.item].imagesData.images.last?.source ?? ""
        
        let placeHoderImage = CustomMethods.placeholderImageWithSize(cell.imageView.frame.size)
        cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHoderImage)
        
//        if (selectedIndex[indexPath.item] == true)
//        {
//            cell.selectedIndicator.backgroundColor = .blue
//        }
//        else
//        {
//            cell.selectedIndicator.backgroundColor = UIColor.white
//        }
        
        if selectedImagesIndex.contains(indexPath.item)
        {
            var selectColor = UIColor()
            if CommonVariables.selectedImageColor != nil
            {
                selectColor = CommonVariables.selectedImageColor!
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
        
        if (CommonVariables.imagesCorners != nil)
        {
            cell.imageView.layer.cornerRadius   = CommonVariables.imagesCorners!
        }
        
        
        if indexPath.item == facebookAlbumsData.imagesData.count - 1
        {
            getDataOfCurrentPage(facebookAlbumsData.paging.next)
        }
        
        return cell
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if selectedIndex[indexPath.item] == true
//        {
//            selectedIndex[indexPath.item] = false
//        }
//        else
//        {
//            selectedIndex[indexPath.item] = true
//        }
        
        if CommonVariables.selectionType == SelectionType.singleSelection
        {
            selectedImagesIndex = [indexPath.item]
        }
        else
        {
            if CommonVariables.selectionType == SelectionType.singleSelection
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
        }
        collectionviewImages.reloadData()
    }
    
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell(collectionviewImages.frame.width)
    }
    

    /**************************************************************************************/
    // MARK: -  ------------------------ Custom methods for gettig images for every album ----------------------------
    /**************************************************************************************/
    
    func getImageFromId(_ imagesData : [[String : Any]])
    {
        //for imgData in imagesData
        
        if loopCounterForGetImagesAndData < imagesData.count
        {
            let imgData = imagesData[loopCounterForGetImagesAndData]
            let albumImages = FacebookAlbumsImages()
            
            albumImages.createTime = CustomMethods.getStringValue(keyString: "created_time", dictionary: imgData)
            albumImages.image_id   = CustomMethods.getStringValue(keyString: "id", dictionary: imgData)
            
            let strAlbumid = "/\(albumImages.image_id)/?fields=images"
            
            let imageReq = GraphRequest.init(graphPath: strAlbumid, httpMethod: .get)
            imageReq.start { (conn, result, error) in
                
                if (error == nil)
                {
                    //print(result ?? "")
                    
                    if let responseResult = result as? [String : Any]
                    {
                        let albumsImageData = ImagesDataAgainstFBAlbumsImageId()
                        
                        albumsImageData.id = CustomMethods.getStringValue(keyString: "id", dictionary: responseResult)
                        if let imagesResult = CustomMethods.getDictArrayValue(keyString: "images", dictionary: responseResult)
                        {
                            for imagesDataResponse in imagesResult
                            {
                                let imagData    = FacebookAlbumsEverySingleImageDetail()
                                
                                imagData.height = CustomMethods.getStringValue(keyString: "height", dictionary: imagesDataResponse)
                                imagData.source = CustomMethods.getStringValue(keyString: "source", dictionary: imagesDataResponse)
                                imagData.width  = CustomMethods.getStringValue(keyString: "width", dictionary: imagesDataResponse)
                                
                                albumsImageData.images.append(imagData)
                            }
                        }
                        albumImages.imagesData = albumsImageData
                    }
                }
                self.loopCounterForGetImagesAndData += 1
                self.facebookAlbumsData.imagesData.append(albumImages)
                self.getImageFromId(imagesData)
            }
        }
        else
        {
            /// code for selected items
//            for i in 0..<self.facebookAlbumsData.imagesData.count
//            {
//                if let val = self.selectedIndex[i]
//                {
//                    self.selectedIndex[i] = val
//                }
//                else
//                {
//                    self.selectedIndex[i] = false
//                }
//            }
            
            collectionviewImages.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    //*******************************************************************************************/
    
    func getDataOfCurrentPage(_ webUrl : String?)
    {
        /// condition for pagination, if is nil than first time record retriving if record iof next page than webUrl will not be empty or nil , if empty string than no more page ahead
        if (webUrl == "")
        {
            return
        }
        
        activityIndicator.startAnimating()
        if webUrl == nil
        {
            let strAlbumid = "/\(facebookAlbums.album_id)/photos"
            let imageReq = GraphRequest.init(graphPath: strAlbumid, httpMethod: .get)
            imageReq.start { (conn, result, error) in
                
                self.activityIndicator.stopAnimating()
                if (error == nil)
                {
                    //print(result ?? "")
                    
                    if let data = result as? [String : Any]
                    {
                        self.dictionaryDataPopulateInFacebookAlbumsDataObject(data)
                    }
                }
            }
        }
        else
        {
            //facebookAlbumsData = nil
            loopCounterForGetImagesAndData = 0
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 10
            
            guard let httpUrl = URL(string: webUrl!) else {return}
            manager.request(httpUrl).responseJSON { (response) in
                
                switch response.result
                {
                case .success(let value):
                    
                    //print(value)
                    let data = value
//                    {
                    //print(data)
                        let dictionary = NSDictionary.init(object: data, forKey: "json" as NSCopying)
                        let jsonDict = dictionary.object(forKey: "json") as! NSDictionary
                        //print(jsonDict)

                        if let dataDict = jsonDict as? [String : Any]
                        {
                            self.dictionaryDataPopulateInFacebookAlbumsDataObject(dataDict)
                        }
//                    }
                    
                case .failure(let error):
                    
                    self.activityIndicator.stopAnimating()
                    print("error accoured \(error.localizedDescription)")
                }
            }
        }
    }
    
    //*******************************************************************************************/
    
    func dictionaryDataPopulateInFacebookAlbumsDataObject (_ responseDict : [String : Any])
    {
        if let imagesData = CustomMethods.getDictArrayValue(keyString: "data", dictionary: responseDict)
        {
            self.getImageFromId(imagesData)
        }
        
        if let paging = CustomMethods.getDictionaryValue(keyString: "paging", dictionary: responseDict)
        {
            let pagingData = FacebookAlbumsPaging()
            
            if let cursors = CustomMethods.getDictionaryValue(keyString: "cursors", dictionary: paging)
            {
                let albumsCursors = FacebookAlbumPagingCusors()
                
                albumsCursors.after     = CustomMethods.getStringValue(keyString: "after", dictionary: cursors)
                albumsCursors.before    = CustomMethods.getStringValue(keyString: "before", dictionary: cursors)
                
                pagingData.cursors = albumsCursors
            }
            
            pagingData.next     = CustomMethods.getStringValue(keyString: "next", dictionary: paging)
            pagingData.previous = CustomMethods.getStringValue(keyString: "previous", dictionary: paging)
            
            self.facebookAlbumsData.paging = pagingData
        }
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controllers lifeCycle -----------------------------
    /**************************************************************************************/
    
    @IBAction func cancelBUttonTapped(_ sender: Any)
    {
        var mediaURL = [URL]()
        for i in selectedImagesIndex
        {
            let imagesArray     = facebookAlbumsData.imagesData[i].imagesData.images
            let imageUrl        = imagesArray[imagesArray.count - 2].source
            guard let url             = URL(string: imageUrl) else {return}
            mediaURL.append(url)
        }
        
        if mediaURL.count > 0
        {
            delegate?.didFinishMediaPickingFromFacebook(mediaURL)
        }
    }
    
    /**************************************************************************************/
    
    @IBAction func doneButtonTapped(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
}

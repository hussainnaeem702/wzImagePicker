//
//  FacebookAlbumsViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 30/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAlbumsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var facebookAlbums                  = [FacebookAlbums]()
    let loginManager                    = LoginManager()
    var loopCounterForGetImagesAndData  = 0
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Outlets  -----------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var collectionviewAlbums : UICollectionView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controllers lifeCycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loopCounterForGetImagesAndData = 0
        
        loginManager.logIn(permissions: ["public_profile", "user_photos", "email", "user_friends"], from: self) { (result, error) in
            if error != nil
            {
                print(error?.localizedDescription ?? "")
            }
            else
            {
                self.getDataOfFacebookProfile()
            }
        }
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Collectionview Delegate and Datasource -----------------------------
    /**************************************************************************************/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return facebookAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAlbumCollectionViewCell", for: indexPath) as! WZAlbumCollectionViewCell
        cell.setBorderWidth(1 / UIScreen.main.scale)
        
        let fbAlbum = facebookAlbums[indexPath.item]
        
        cell.populateCellsDataForFacebookSDk(fbAlbum)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CustomMethods.standardSizeOfcollectionviewCell(collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let album      = facebookAlbums[indexPath.item]
        
        let assestVc                = self.storyboard?.instantiateViewController(withIdentifier: "FacebookAlbumImagesViewController") as! FacebookAlbumImagesViewController
        assestVc.facebookAlbums     = album
        self.navigationController?.pushViewController(assestVc, animated: true)
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
                print(result ?? "")
                if let responseResult = result as? [String : Any]
                {
                    if let data = CustomMethods.getDictArrayValue(keyString: "data", dictionary: responseResult)
                    {
                        print(data)
                        
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
                                    print(result ?? "")
                                    if let responseResult = result as? [String : Any]
                                    {
                                        if let picData = CustomMethods.getDictionaryValue(keyString: "picture", dictionary: responseResult)
                                        {
                                            print(picData)
                                            if let imageUrlData = CustomMethods.getDictionaryValue(keyString: "data", dictionary: picData)
                                            {
                                                print(imageUrlData )
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
                print(error ?? "")
            }
        }
    }

}

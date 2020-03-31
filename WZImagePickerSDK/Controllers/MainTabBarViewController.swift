//
//  MainTabBarViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 27/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import Photos

protocol WzPickerDelegateTabBar {
    func didFinishSelectionTabBar(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?, _ mediaURLs : [URL]?)
    func didCancelTabBar()
}

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate, WzSelectedPictureDelegate, WzCaptureImageCameraDelegate, WzPassMediaFromFacebookDelegate {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var delegateCall       : WzPickerDelegateTabBar?
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controllers LifeCycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.delegate      = self
        
        /// initially assign delegate WZAlbumsViewController controller 
        if let controllers = self.viewControllers
        {
            for controller in controllers
            {
                if controller.isKind(of: WZAlbumsViewController.self)
                {
                    if let wzAlbums = controller as? WZAlbumsViewController
                    {
                        wzAlbums.delegate                       = self
//                        wzAlbums.backgroundColor                = CommonVariables.backgroundColor
//                        wzAlbums.topSectionColor                = CommonVariables.topSectionColor
//                        wzAlbums.highLightedIndicatorColor      = CommonVariables.highLightedIndicatorColor
//                        wzAlbums.topButtonsTextColor            = CommonVariables.topButtonsTextColor
//                        wzAlbums.albumsCellBackgoundColor       = CommonVariables.albumsCellBackgoundColor
//                        wzAlbums.albumsImageBorderColor         = CommonVariables.albumsImageBorderColor
//                        wzAlbums.albumsTextColor                = CommonVariables.albumsTextColor
//                        wzAlbums.selectedImageColor             = CommonVariables.selectedImageColor
//                        wzAlbums.topButtonsSepratorviewBGColor  = CommonVariables.topButtonsSepratorviewBGColor
//                        wzAlbums.imagesBorderWidth              = CommonVariables.imagesBorderWidth
//                        wzAlbums.albumsBorderCorners            = CommonVariables.albumsBorderCorners
//                        wzAlbums.imagesCorners                  = CommonVariables.imagesCorners
//                        wzAlbums.selectedType                   = CommonVariables.selectedType
//                        wzAlbums.selectionType                  = CommonVariables.selectionType
                    }
                }
            }
        }
    }
    

    /**************************************************************************************/
    // MARK: -  ------------------------ tabbar Delegate Methods -----------------------------
    /**************************************************************************************/
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController.isKind(of: WZAlbumsViewController.self)
        {
            if let wzAlbums = viewController as? WZAlbumsViewController
            {
                wzAlbums.delegate                       = self
//                wzAlbums.backgroundColor                = CommonVariables.backgroundColor
//                wzAlbums.topSectionColor                = CommonVariables.topSectionColor
//                wzAlbums.highLightedIndicatorColor      = CommonVariables.highLightedIndicatorColor
//                wzAlbums.topButtonsTextColor            = CommonVariables.topButtonsTextColor
//                wzAlbums.albumsCellBackgoundColor       = CommonVariables.albumsCellBackgoundColor
//                wzAlbums.albumsImageBorderColor         = CommonVariables.albumsImageBorderColor
//                wzAlbums.albumsTextColor                = CommonVariables.albumsTextColor
//                wzAlbums.selectedImageColor             = CommonVariables.selectedImageColor
//                wzAlbums.topButtonsSepratorviewBGColor  = CommonVariables.topButtonsSepratorviewBGColor
//                wzAlbums.imagesBorderWidth              = CommonVariables.imagesBorderWidth
//                wzAlbums.albumsBorderCorners            = CommonVariables.albumsBorderCorners
//                wzAlbums.imagesCorners                  = CommonVariables.imagesCorners
//                wzAlbums.selectedType                   = CommonVariables.selectedType
//                wzAlbums.selectionType                  = CommonVariables.selectionType
            }
        }
        else if viewController.isKind(of: WZCameraViewController.self)
        {
            if let wzCamera = viewController as? WZCameraViewController
            {
                wzCamera.delegate = self
            }
        }
        else if viewController.isKind(of: FacebookAlbumsViewController.self)
        {
            if let wzFacebook = viewController as? FacebookAlbumsViewController
            {
                wzFacebook.delegate                       = self
//                wzFacebook.backgroundColor                = CommonVariables.backgroundColor
//                wzFacebook.activityIndicatorViewColor     = CommonVariables.activityIndicatorBgColor
//                wzFacebook.topSectionColor                = topSectionColor
//                wzFacebook.highLightedIndicatorColor      = highLightedIndicatorColor
//                wzFacebook.topButtonsTextColor            = topButtonsTextColor
//                wzFacebook.albumsCellBackgoundColor       = CommonVariables.albumsCellBackgoundColor
//                wzFacebook.albumsImageBorderColor         = CommonVariables.albumsImageBorderColor
//                wzFacebook.albumsTextColor                = CommonVariables.albumsTextColor
//                wzFacebook.selectedImageColor             = CommonVariables.selectedImageColor
//                wzFacebook.topButtonsSepratorviewBGColor  = topButtonsSepratorviewBGColor
//                wzFacebook.imagesBorderWidth              = CommonVariables.imagesBorderWidth
//                wzFacebook.albumsBorderCorners            = CommonVariables.albumsBorderCorners
//                wzFacebook.imagesCorners                  = CommonVariables.imagesCorners
//                wzFacebook.selectedType                   = CommonVariables.selectedType
//                wzFacebook.selectionType                  = CommonVariables.selectionType
            }
        }
        
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Custom delegate methods for pick media from Gallery -----------------------------
    /**************************************************************************************/
    
    func didFinishSelection(_ mediaAssest: [PHAsset]?, _ images: [UIImage]?)
    {
        delegateCall?.didFinishSelectionTabBar(mediaAssest, nil, nil)
    }
    
    /********************************************/
    
    func didCancel()
    {
        delegateCall?.didCancelTabBar()
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Custom delegate methods for pick media from Camera -----------------------------
    /**************************************************************************************/

    func didFinishCapturePicture(_ mediaAssest: [PHAsset]?, _ images: [UIImage]?) {
        delegateCall?.didFinishSelectionTabBar(mediaAssest, images, nil)
    }
    
    func didCancelCaptures() {
        delegateCall?.didCancelTabBar()
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Custom delegate methods for pick media from Facebook -----------------------------
    /**************************************************************************************/
    
    func didFinishSelectionMediaFromFacebook(_ selectedMeidaURLs: [URL]) {
        delegateCall?.didFinishSelectionTabBar(nil, nil, selectedMeidaURLs)
    }
    
    func didCancelFacebook() {
        delegateCall?.didCancelTabBar()
    }
}

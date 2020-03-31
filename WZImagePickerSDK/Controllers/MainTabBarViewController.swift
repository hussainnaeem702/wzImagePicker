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
    var activityIndicatorBgColor        : UIColor?              = nil
    var imagesBorderWidth               : CGFloat?              = nil
    var albumsBorderCorners             : CGFloat?              = nil
    var imagesCorners                   : CGFloat?              = nil
    var selectedType                    : SelectedMediaType?    = nil
    var selectionType                   : SelectionType?        = SelectionType.multipleSelection
    
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
                        wzAlbums.delegate   = self
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
                wzAlbums.backgroundColor                = backgroundColor
                wzAlbums.topSectionColor                = topSectionColor
                wzAlbums.highLightedIndicatorColor      = highLightedIndicatorColor
                wzAlbums.topButtonsTextColor            = topButtonsTextColor
                wzAlbums.albumsCellBackgoundColor       = albumsCellBackgoundColor
                wzAlbums.albumsImageBorderColor         = albumsImageBorderColor
                wzAlbums.albumsTextColor                = albumsTextColor
                wzAlbums.selectedImageColor             = selectedImageColor
                wzAlbums.topButtonsSepratorviewBGColor  = topButtonsSepratorviewBGColor
                wzAlbums.imagesBorderWidth              = imagesBorderWidth
                wzAlbums.albumsBorderCorners            = albumsBorderCorners
                wzAlbums.imagesCorners                  = imagesCorners
                wzAlbums.selectedType                   = selectedType
                wzAlbums.selectionType                  = selectionType
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
                wzFacebook.backgroundColor                = backgroundColor
                wzFacebook.activityIndicatorViewColor     = activityIndicatorBgColor
//                wzFacebook.topSectionColor                = topSectionColor
//                wzFacebook.highLightedIndicatorColor      = highLightedIndicatorColor
//                wzFacebook.topButtonsTextColor            = topButtonsTextColor
                wzFacebook.albumsCellBackgoundColor       = albumsCellBackgoundColor
                wzFacebook.albumsImageBorderColor         = albumsImageBorderColor
                wzFacebook.albumsTextColor                = albumsTextColor
                wzFacebook.selectedImageColor             = selectedImageColor
//                wzFacebook.topButtonsSepratorviewBGColor  = topButtonsSepratorviewBGColor
                wzFacebook.imagesBorderWidth              = imagesBorderWidth
                wzFacebook.albumsBorderCorners            = albumsBorderCorners
                wzFacebook.imagesCorners                  = imagesCorners
                wzFacebook.selectedType                   = selectedType
                wzFacebook.selectionType                  = selectionType
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

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
    func didFinishSelectionTabBar(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?)
    func didCancelTabBar()
}

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate, WzSelectedPictureDelegate, WzCaptureImageCameraDelegate {

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
                    print("WzPicker ... controller selected ..................")
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
        print("Selected view Controller is \(viewController)")
        
        if viewController.isKind(of: WZAlbumsViewController.self)
        {
            print("WzPicker ... controller selected ..................")
            if let wzAlbums = viewController as? WZAlbumsViewController
            {
                wzAlbums.delegate   = self
            }
        }
        else if viewController.isKind(of: WZCameraViewController.self)
        {
            print("nothinf ffnffinjdnjcdnc cinence ")
            if let wzCamera = viewController as? WZCameraViewController
            {
                wzCamera.delegate = self
            }
        }
        
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Custom delegate methods for pick media from Gallery -----------------------------
    /**************************************************************************************/
    
    func didFinishSelection(_ mediaAssest: [PHAsset]?, _ images: [UIImage]?)
    {
        delegateCall?.didFinishSelectionTabBar(mediaAssest, nil)
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
        delegateCall?.didFinishSelectionTabBar(mediaAssest, images)
    }
    
    func didCancelCaptures() {
        delegateCall?.didCancelTabBar()
    }
}

//
//  Common.swift
//  imagePickerWz
//
//  Created by Adeel on 20/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation
import UIKit
import Photos

/// protocol delegate method  for return back data to accesssable viewcontroller
public protocol WZImagePickerDelegate {
    
    func didFinishPickImage(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?, _ mediaURLs : [URL]?)
    func didCancelPickImage()
}

public class WZPickerController: NSObject, WzPickerDelegateTabBar {
    
    
    /// if these variables are nil than use default behaviour
    public var backgroundColor               : UIColor?               = nil /// accessable varibale for set main background color of screen
    public var topSelectionButtonColor       : UIColor?               = nil /// accessable varibale for set top button selections backgound color
    public var topHighlightedIndicatorColor  : UIColor?               = nil ///  accessable varibale for set selected button highlight view's color
    public var topButtonTextColor            : UIColor?               = nil ///  accessable varibale for set top selection buttons text color
    public var albumsCellBackgoundColor      : UIColor?               = nil ///  accessable varibale for set each cells backgound color
    public var albumsImageBorderColors       : UIColor?               = nil ///  accessable varibale for set each cells border color
    public var albumsTextColor               : UIColor?               = nil ///  accessable varibale for set each cells text color
    public var selectedImageColor            : UIColor?               = nil ///  accessable varibale for set selected images indicator color
    public var topButtonSepratorViewColor    : UIColor?               = nil ///  accessable varibale for set buttons seprator view background color
    public var activityIndicatorBgColor      : UIColor?               = nil ///  accessable varibale for set background color of spinner/ loader view 
    public var albumsBorderCorners           : CGFloat?               = nil ///  accessable varibale for set each cell border
    public var imagesCorners                 : CGFloat?               = nil ///  accessable varibale for set images corners
    public var imagesBorderWidth             : CGFloat?               = nil ///  accessable varibale for set images border
    public var selectedMediaType             : SelectedMediaType?     = nil ///  accessable varibale for set media type either video or image if nil than both
    public var selectionType                 : SelectionType?         = nil ///  accessable varibale for set single selection or multiple selection
    public var delegate                      : WZImagePickerDelegate? = nil///  accessable varibale for set delagte
                
    
    
    public func show(_ fromController : UIViewController)
    {
        //        let wzAlbums                = WZAlbumsViewController()
        
        let podBundle  = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "WzPicker", bundle: podBundle)
        //let wzAlbums   = storyboard.instantiateViewController(withIdentifier: "WZAlbumsViewController") as! WZAlbumsViewController
        if let wzTabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController {
            
            
            CommonVariables.backgroundColor                 = backgroundColor
            CommonVariables.topSectionColor                 = topSelectionButtonColor
            CommonVariables.highLightedIndicatorColor       = topHighlightedIndicatorColor
            CommonVariables.albumsCellBackgoundColor        = albumsCellBackgoundColor
            CommonVariables.albumsImageBorderColor          = albumsImageBorderColors
            CommonVariables.albumsBorderCorners             = albumsBorderCorners
            CommonVariables.imagesCorners                   = imagesCorners
            CommonVariables.imagesBorderWidth               = imagesBorderWidth
            CommonVariables.albumsTextColor                 = albumsTextColor
            CommonVariables.selectedImageColor              = selectedImageColor
            CommonVariables.topButtonsTextColor             = topButtonTextColor
            CommonVariables.selectedType                    = selectedMediaType
            CommonVariables.selectionType                   = selectionType
            CommonVariables.topButtonsSepratorviewBGColor   = topButtonSepratorViewColor
            CommonVariables.activityIndicatorBgColor        = activityIndicatorBgColor
            wzTabBar.delegateCall                           = self
            
            
            fromController.present(wzTabBar, animated: true, completion: nil)
            if (backgroundColor != nil)
            {
            }
            
            if (topSelectionButtonColor != nil)
            {
            }
            
            if (topHighlightedIndicatorColor != nil)
            {
            }
            
            if (albumsCellBackgoundColor != nil)
            {
            }
            
            if (albumsImageBorderColors != nil)
            {
            }
            
            if (albumsBorderCorners != nil)
            {
            }
            
            if (imagesCorners != nil)
            {
            }
            
            if (imagesBorderWidth != nil)
            {
            }
            
            if (albumsTextColor != nil)
            {
            }
            
            if (selectedImageColor != nil)
            {
            }
            
            if (topButtonTextColor != nil)
            {
            }
            
            if (selectedMediaType != nil)
            {
            }
            
            if (selectionType != nil)
            {
            }
            
            if (topButtonSepratorViewColor != nil)
            {
            }
            
            if (activityIndicatorBgColor != nil)
            {
            }
        }
    }
    
    /**************************************************************************************/
    // MARK: -  ---------------- Custom Delegate Methods ---------------
    /**************************************************************************************/
    
    /// after image selection done from all photos or each albums phonts than this delagte method called and same delegate will again call tu custom user class
    
    func didFinishSelectionTabBar(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?, _ mediaURLs : [URL]?)
    {
        delegate?.didFinishPickImage(mediaAssest, images, mediaURLs)
    }
    
    func didCancelTabBar() {
        delegate?.didCancelPickImage()
    }
    
}


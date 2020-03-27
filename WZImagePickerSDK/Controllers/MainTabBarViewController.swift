//
//  MainTabBarViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 27/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit


class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var tabbarSelectedItem = Int()
    
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

         self.delegate = self
    }
    

    /**************************************************************************************/
    // MARK: -  ------------------------ tabbar Delegate Methods -----------------------------
    /**************************************************************************************/
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        tabbarSelectedItem = item.tag
        
        if item.tag == 0
        {
            print("WzPicker ... controller selected ..................")
        }
        else if item.tag == 1
        {
            print("camera ... controller selected ..................")
        }
        else if item.tag = 2
        {
            print("insta ... controller selected ..................")
        }
        else
        {
            print("facebook ... controller selected ..................")
        }
    }
    
    /**************************************************************************************/
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("selected view controller \(tabbarSelectedItem)")
        print("Selected view Controller is \(viewController)")
        
        if viewController.isKind(of: WZAlbumsViewController.self)
        {
            print("WzPicker ... controller selected ..................")
        }
        else
        {
            print("nothinf ffnffinjdnjcdnc cinence ")
        }
        
    }

}

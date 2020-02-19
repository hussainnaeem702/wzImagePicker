//
//  WzPicker.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 18/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation
import UIKit


public class WZPickerBase {
    
    init() {}
    
    public func showPickerController(_ fromViewController : UIViewController)
    {
        let assetBundle = Bundle(for: type(of: self))
        let wzPicker = WZAlbumsViewController(nibName: "WZAlbumsViewController", bundle: assetBundle)
        fromViewController.present(wzPicker, animated: true, completion: nil)
    }
}

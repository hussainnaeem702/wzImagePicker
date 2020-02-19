//
//  WzPicker.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 18/02/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation
import UIKit


public class HelloWorld {
    let hello = "Hello"

    public init() {}
    public func hello(to whom: String) -> String {
        return "Hello \(whom)"
    }
    
    public func showPickerController(_ fromViewController : UIViewController)
    {
        let wzPicker = WZAlbumsViewController(nibName: "WZAlbumsViewController", bundle: nil)
        fromController.present(wzPicker, animated: true, completion: nil)
    }
}

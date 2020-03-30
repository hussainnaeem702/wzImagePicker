//
//  InstagramMediaData.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 30/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation

class InstagramImages: NSObject {
    
    var lowResolution       = InstagramImagesData()
    var standardResolution  = InstagramImagesData()
    var thumbnail           = InstagramImagesData()
}

class InstagramImagesData : NSObject
{
    var height = ""
    var url    = ""
    var width  = ""
}


class InstagramPagination: NSObject {
    
    var nextMaxId = ""
    var nextUrl   = ""
}

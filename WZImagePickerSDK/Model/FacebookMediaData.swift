//
//  FacebookMediaData.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 30/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import Foundation

class FacebookAlbums: NSObject {
    
    var createTime  = ""
    var album_id    = ""
    var name        = ""
    var imageUrl    = ""
}



/// Classes for Every Single Albums

class FacebookAlbumsData: NSObject
{
    
    var imagesData  = [FacebookAlbumsImages]()
    var paging      = FacebookAlbumsPaging()
}

class FacebookAlbumsImages : NSObject
{
    var createTime = ""
    var image_id   = ""
    var imagesData = ImagesDataAgainstFBAlbumsImageId()
}

class FacebookAlbumsPaging: NSObject
{
    var cursors     = FacebookAlbumPagingCusors()
    var next        = ""
    var previous    = ""
}

class FacebookAlbumPagingCusors: NSObject
{
    var after   = ""
    var before  = ""
}

class ImagesDataAgainstFBAlbumsImageId: NSObject {
    
    var id      = ""
    var images  = [FacebookAlbumsEverySingleImageDetail]()
}

class FacebookAlbumsEverySingleImageDetail : NSObject
{
    var height = ""
    var source = ""
    var width  = ""
}

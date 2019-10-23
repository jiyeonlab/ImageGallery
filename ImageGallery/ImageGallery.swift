//
//  Image.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

protocol GalleryCenter {
    var galleryCenter: [ImageGallery]! {get}
}

class ImageGallery {
    
    // ImageGallery 안에는 Image 구조체의 배열이 들어간다.
    struct Image {
        var url: URL?
        var aspectRatio = CGFloat(1.0)
    }
    
    var images = [Image]()
    var galleryName = String("")
}


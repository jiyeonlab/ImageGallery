//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let urlContents = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let imageData = UIImage(data: urlContents) {
                            print("Success Loading")
                            self.imageView.image = imageData
                        }else {
                            print("Failed Loading")
                            let failImage = UIImage(named: "Fail_Icon")
                            self.imageView.image = failImage
                        }
                    }
                }
            }
        }
    }
}

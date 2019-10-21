//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {
    
    var images = [Image]()
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            imageCollectionView.dropDelegate = self
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.imageURL = images[indexPath.item].url
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageWidth: CGFloat = collectionView.bounds.size.width / 3.4
        
        print("width : \(imageWidth)")
        
        let imageHeight = imageWidth / images[indexPath.item].aspectRatio
        
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    // MARK: UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: images.count, section: 0)
        
        for item in coordinator.items {
            let placeholderCell = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
            
            var newImage = Image()
            
            // TASK 3번
            item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                DispatchQueue.main.async {
                    if let image = provider as? UIImage {
                        print("Yes image")
                        newImage.aspectRatio = image.size.width / image.size.height
                        print("aspectRatio : \(image.size.width / image.size.height)")
                    }else {
                        placeholderCell.deletePlaceholder()
                    }
                }
            }
            
            item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                DispatchQueue.main.async {
                    if let url = provider as? URL {
                        print("Yes url")
                        newImage.url = url
                        
                        // TASK 8번
                        placeholderCell.commitInsertion { (insertionIndex) in
                            self.images.insert(newImage, at: destinationIndexPath.item)
                        }
                    }else{
                        placeholderCell.deletePlaceholder()
                    }
                }
            }
        }
    }
    
}

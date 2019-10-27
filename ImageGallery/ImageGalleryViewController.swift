//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UIDropInteractionDelegate {
    
    var imageGallery: ImageGallery = ImageGallery()
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            imageCollectionView.dropDelegate = self
            imageCollectionView.dragDelegate = self
            
            imageCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(resizeCell(_:))))
        }
    }
    
    
    var imageWidthConstant: CGFloat = 1.0
    @objc func resizeCell(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .ended, .changed:
            imageWidthConstant = sender.scale
            imageCollectionView.collectionViewLayout.invalidateLayout()
        default:
            break
        }
        
        
    }
    
    // Add trash button
    @IBOutlet weak var trashButton: UIBarButtonItem! {
        didSet {
            navigationController?.navigationBar.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("yes delete!")
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print("here")
        return UIDropProposal(operation: .move)
    }
    
    var currentDragImageIndex: [IndexPath] = []
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // image를 collection view 목록에서 삭제하고, view 전체를 업데이트 해줘야 함.
        print("perfromdrop")
        if let currentIndex = currentDragImageIndex.first?.item {
            print("currentIndex = \(currentIndex)")
            imageGallery.images.remove(at: currentIndex)
            imageCollectionView.deleteItems(at: currentDragImageIndex)
        }
        currentDragImageIndex.removeAll()
        
    }
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
//            imageCell.imageURL = images[indexPath.item].url
            imageCell.imageURL = imageGallery.images[indexPath.item].url
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let imageWidth: CGFloat = collectionView.bounds.size.width / 3.4

        let imageHeight = 200 * imageWidthConstant / imageGallery.images[indexPath.item].aspectRatio

        return CGSize(width: 200 * imageWidthConstant, height: imageHeight)
        //return CGSize(width: imageWidth, height: imageHeight)
        //return CGSize(width: 200.0, height: 200.0)
    }
    
    // MARK: UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        //print("drag image")
        session.localContext = collectionView
        
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let selectItem = (imageCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageURL {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: selectItem as NSItemProviderWriting))
            
            dragItem.localObject = selectItem
            currentDragImageIndex += [indexPath]
            
            return [dragItem]
        }else{
            return []
        }
    }
    
    // MARK: UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = ((session.localDragSession?.localContext) as? UICollectionView) == collectionView
        
        if isSelf {
            return session.canLoadObjects(ofClass: URL.self)
        }else {
            return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = ((session.localDragSession?.localContext) as? UICollectionView) == collectionView
        
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        //return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: images.count, section: 0)
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: imageGallery.images.count, section: 0)
        
        for item in coordinator.items {
            
            // collectionView 내에서 움직일 때.
            if let sourceIndexPath = item.sourceIndexPath
            {
                if let dragItemURL = (item.dragItem.localObject) as? URL {
                    
                    collectionView.performBatchUpdates({
                        // 모델 먼저 업데이트.
//                        var newImage = Image()
//                        newImage.url = dragItemURL
//                        images.remove(at: sourceIndexPath.item)
//                        images.insert(newImage, at: destinationIndexPath.item)
                        // 모델 먼저 업데이트
                        var newImage = ImageGallery.Image() //  aspectRatio, url을 변수로 가지는 Image 구조체 하나를 선언하는 것임.
                        newImage.url = dragItemURL
                        imageGallery.images.remove(at: sourceIndexPath.item)
                        imageGallery.images.insert(newImage, at: destinationIndexPath.item)
                        
                        // collectionView를 업데이트
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    
                    // drop animate
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            
            // 앱 외부에서 앱으로 가져올 때.
            else
            {
                let placeholderCell = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                
                //var newImage = Image()
                var newImage = ImageGallery.Image()
                
                // TASK 3번
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            newImage.aspectRatio = image.size.width / image.size.height
                            //print("aspectRatio : \(image.size.width / image.size.height)")
                        }else {
                            placeholderCell.deletePlaceholder()
                        }
                    }
                }
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            //newImage.url = url
                            newImage.url = url
                            
                            // TASK 8번
                            placeholderCell.commitInsertion { (insertionIndex) in
                                //self.images.insert(newImage, at: destinationIndexPath.item)
                                self.imageGallery.images.insert(newImage, at: destinationIndexPath.item)
                            }
                        }else{
                            placeholderCell.deletePlaceholder()
                        }
                    }
                }
            }
            
        }
    }
    
    // ImageViewController로 segue 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let clickImage = sender as? ImageCollectionViewCell {
            if let imageVC = segue.destination.contents as? ImageViewController {
                //print("이제 url 넣어주자")
                imageVC.imageURL = clickImage.imageURL
                imageVC.title = (sender as? ImageGalleryViewController)?.navigationItem.title
            }
        }
        
    }
    
}

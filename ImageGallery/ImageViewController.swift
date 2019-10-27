//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/25.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // imageView에 저장할 이미지를 변수로 따로 빼줬음.
    private var image: UIImage? {
        // 이미지를 지정하거나 가져올 때, imageView로부터 가져올 것임.
        get {
            return imageView.image
        }
        set {
            scrollView?.zoomScale = 1.0
            imageView.image = newValue
            
            // 콘텐츠 크기를 프레임 크기와 같게 둔다.
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            
            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            
            spinner?.stopAnimating()
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
    }
    
    // viewDidApper()는 뷰가 나타난 직후.
    // view가 나타났는데도, 이미지가 nil이라면 fetchImage() 해줌.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    var imageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    private func fetchImage() {
            
            // 우선 imageURL을 가져온다.
            if let url = imageURL {
                spinner.startAnimating()
                DispatchQueue.global(qos: .userInitiated ).async { [weak self] in
                    let urlContents = try? Data(contentsOf: url)
                    
                    // UI와 관련된 작업은 메인큐에서 실행해야함.
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL {
                            //imageView.image = UIImage(data: imageData)
                            self?.image = UIImage(data: imageData)
                        }
                    }
                    
                }
            }
        }
        
        // 화면 초기.
        override func viewDidLoad() {
            super.viewDidLoad()
    //        if imageURL == nil {
    //            imageURL = DemoURLs.stanford
    //        }
        }
}

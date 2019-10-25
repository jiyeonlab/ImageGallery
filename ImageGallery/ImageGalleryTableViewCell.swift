//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/25.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    //weak var parentView = ImageGalleryTableViewController()
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.isUserInteractionEnabled = false
        }
    }
    
    func tapSetting() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped(_:)))
        doubleTap.numberOfTapsRequired = 2
        textField.addGestureRecognizer(doubleTap)
        
    }
    
    var resignationHandler: (() -> Void)?
    
    @objc func doubleTaped(_ sender: UITapGestureRecognizer) {
        print("doubleTaped()")
        
        if sender.state == .ended {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        
        resignationHandler?()
        
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

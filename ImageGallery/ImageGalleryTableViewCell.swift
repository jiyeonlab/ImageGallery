//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/25.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.isUserInteractionEnabled = false
        }
    }
    
    var resignationHandler: ((_ newName: String) -> Void)?
    
    /// cell에 tap gesture를 add해주는 메소드
    func tapSetting() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped(_:)))
        doubleTap.numberOfTapsRequired = 2
        textField.addGestureRecognizer(doubleTap)
        
    }
    
    /// cell을 더블클릭하면 수행되는 메소드
    @objc func doubleTaped(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        
        resignationHandler?(_: textField.text ?? "")
        
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

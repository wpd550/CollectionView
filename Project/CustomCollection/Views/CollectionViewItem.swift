//
//  CollectionViewItem.swift
//  CustomCollection
//
//  Created by dong on 2020/12/15.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    
    var imageFile:ImageFile?{
        didSet{
            guard isViewLoaded else {
                return
            }
            
            if let  imageFile = imageFile{
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            }else{
                imageView?.image = nil
                textField?.stringValue = " "
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
    
    
}

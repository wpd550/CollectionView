//
//  CollectionViewItem.swift
//  CustomCollection
//
//  Created by dong on 2020/12/15.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak open var checkBox: NSButton?
    var action: Selector?
    weak var target: AnyObject?

    var indexPath:IndexPath?
    
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
        view.layer?.borderWidth = 0.0
        // 2
        view.layer?.borderColor = NSColor.blue.cgColor
        
        //bind KVB模式
        checkBox?.bind(NSBindingName(rawValue: #keyPath(NSButton.state)), to: self, withKeyPath: #keyPath(CollectionViewItem.isSelected), options: nil)
    }
    
    func setHighlight(selected: Bool) {
      view.layer?.borderWidth = selected ? 5.0 : 0.0
    }
    
    //MARK: - Action
    
    @IBAction func checkBoxAction(_ sender: Any) {
        print("click checkBox button")
    }
    deinit {
        checkBox?.unbind(NSBindingName(rawValue: #keyPath(NSButton.state)))
    }
    
}

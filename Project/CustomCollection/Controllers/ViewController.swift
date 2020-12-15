//
//  ViewController.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/15.
//

import Cocoa

class ViewController: NSViewController {

    
    let imageDirectoryLoader = ImageDirectoryLoader()

    override func viewDidLoad() {
      super.viewDidLoad()
      let initialFolderUrl:NSURL = NSURL.fileURL(withPath: "/Users/dongwu/Desktop/pictures", isDirectory: true) as NSURL
      imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl)
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
      imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL)
    }


}


//
//  ViewController.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/15.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView:NSCollectionView!
    
    let imageDirectoryLoader = ImageDirectoryLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialFolderUrl:NSURL = NSURL.fileURL(withPath: "/Users/dong/Desktop/picture", isDirectory: true) as NSURL
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl)
        
//        configCollectionViewFlowLayout()
       
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
      imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL)
        collectionView.reloadData()
    }

    
    private func configCollectionViewFlowLayout(){
//        let flowLayout = NSCollectionViewFlowLayout()
//        flowLayout.itemSize = itemSize
//        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
//        flowLayout.minimumInteritemSpacing = 20.0
//        flowLayout.minimumLineSpacing = 20.0
//        collectionView.collectionViewLayout = flowLayout
//        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    
    }
    
    let itemSize:NSSize = NSSize(width: 160, height: 140)
    let lineSpace:CGFloat = 20.0;
    
}


extension ViewController : NSCollectionViewDataSource
{

    func numberOfSections(in collectionView: NSCollectionView) -> Int{
        return imageDirectoryLoader.numberOfSections
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem =  item as? CollectionViewItem else {
            return item
        }
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath as NSIndexPath)
        collectionViewItem.imageFile = imageFile
        return collectionViewItem
    }
    
    
    
}

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
        let initialFolderUrl:NSURL = NSURL.fileURL(withPath: "/Users/dongwu/Desktop/pictures", isDirectory: true) as NSURL
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl)
        configCollectionViewFlowLayout()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        collectionView.reloadData()
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL)
    }

    
    private func configCollectionViewFlowLayout(){
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = itemSize
        flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 20.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = lineSpace
        flowLayout.minimumLineSpacing = lineSpace
        collectionView.collectionViewLayout = flowLayout
        
//        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    
    }
    
    
    @IBAction func hiddenSessionAction(_ sender: Any) {
        let show = (sender as! NSButton).state
        
        imageDirectoryLoader.singleSectionMode = (show == NSControl.StateValue.off)
        imageDirectoryLoader.setupDataForUrls(urls: nil)
        collectionView.reloadData()
    }

    @IBAction func toggleSectionCollapse(_ sender: Any) {
        collectionView.toggleSectionCollapse(sender)
    }
    
    let itemSize:NSSize = NSSize(width: 160, height: 140)
    let lineSpace:CGFloat = 20.0;
    
}

//MARK: - NSCollectionViewDataSource
extension ViewController : NSCollectionViewDataSource
{

    func numberOfSections(in collectionView: NSCollectionView) -> Int{
        let number =  imageDirectoryLoader.numberOfSections
        print("numberOfSections: \(number)")
        return number
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let number =  imageDirectoryLoader.numberOfItemsInSection(section: section)
        print("numberOfItemsInSection: \(number)")
        return number
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
    
    //视图控制
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView
    {
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeadView"), for: indexPath) as! HeadView
        // 2
        view.sectionTitle.stringValue = "Section \(indexPath.section)"
        let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(section: indexPath.section)
        view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        return view
    }
}

//MARK: - NSCollectionViewDelegateFlowLayout
extension ViewController:NSCollectionViewDelegateFlowLayout
{
    //headView   布局约束控制
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize
    {
        return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
    }
    //
//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize
//    {
//        return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
//    }
}


//MARK: - NSCollectionViewDelegate

extension ViewController:NSCollectionViewDelegate
{
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>)
    {
        guard indexPaths.first != nil else {
              return
            }
        for indexPath in indexPaths{
            guard let item = collectionView.item(at: indexPath) else {
                return
            }
            (item as! CollectionViewItem).setHighlight(selected: true)
        }    // 3
        
      
    }
    
    
 
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>)
    {
        guard indexPaths.first != nil else {
             return
           }
        for indexPath in indexPaths{
            guard let item = collectionView.item(at: indexPath) else {
                 return
               }
            (item as! CollectionViewItem).setHighlight(selected: false)
        }  
      
    }

    
}


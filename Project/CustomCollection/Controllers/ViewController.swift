//
//  ViewController.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/15.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView:NSCollectionView!
    
    @IBOutlet weak var addSliderButtom:NSButton!
    
    @IBOutlet weak var removeSlideButton: NSButton!

    
    var indexPathsOfItemsBeingDragged: Set<IndexPath>!

    
    let imageDirectoryLoader = ImageDirectoryLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialFolderUrl:NSURL = NSURL.fileURL(withPath: "/Users/dongwu/Desktop/pictures", isDirectory: true) as NSURL
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: initialFolderUrl)
        configCollectionViewFlowLayout()
        registDragAndDrop()
        
    }
    
    override func viewDidDisappear() {
//        collectionView.reloadData()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadDataForNewFolderWithUrl(folderURL: NSURL) {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL: folderURL)
        collectionView.reloadData()
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
    
    
    func highlightItems(selected: Bool, atIndexPaths: Set<IndexPath>) {
   
        addSliderButtom.isEnabled = collectionView.selectionIndexPaths.count == 1
        
       let isEmpty:Bool = collectionView.selectionIndexPaths.isEmpty
        removeSlideButton.isEnabled = !isEmpty
        
        for indexPath in atIndexPaths{
            print("indexPath = \(indexPath)")
            guard let item = collectionView.item(at: indexPath) else {
                continue
            }
            (item as! CollectionViewItem).setHighlight(selected: selected)
        }
    }

    
    @IBAction func hiddenSessionAction(_ sender: Any) {
        let show = (sender as! NSButton).state
        
        imageDirectoryLoader.singleSectionMode = (show == NSControl.StateValue.off)
        imageDirectoryLoader.setupDataForUrls(urls: nil)
        collectionView.reloadData()
    }

    
    

    //MARK: - Add
    private func insertAtIndexPathFromURLs(urls: [NSURL], atIndexPath: NSIndexPath) {
        var indexPaths: Set<IndexPath> = []
        let section = atIndexPath.section
        var currentItem = atIndexPath.item
        
        // 1
        for url in urls {
            // 2
            let imageFile = ImageFile(url: url)
            let currentIndexPath = NSIndexPath(forItem: currentItem, inSection: section)
            imageDirectoryLoader.insertImage(image: imageFile, atIndexPath: currentIndexPath as IndexPath)
            indexPaths.insert(currentIndexPath as IndexPath)
            currentItem += 1
        }
        
        collectionView.insertItems(at: indexPaths)
        
        
        // 3
    }
    
    @IBAction func addSlide(sender: NSButton) {
        // 4
        let insertAtIndexPath = collectionView.selectionIndexPaths.first!
        //5
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = true;
        openPanel.allowedFileTypes = ["public.image"]
        openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
            guard response.rawValue == NSApplication.ModalResponse.OK.rawValue else {return}
            self.insertAtIndexPathFromURLs(urls: openPanel.urls as [NSURL], atIndexPath: insertAtIndexPath as NSIndexPath)
        }
    }

    @IBAction func test(_ sender: Any) {
        print("selects \(collectionView.selectionIndexPaths)")
    }

    //MARK: - remove
    @IBAction func removeSlide(sender: NSButton) {
        
        let selectionIndexPaths = collectionView.selectionIndexPaths
        if selectionIndexPaths.isEmpty {
            return
        }
        
        // 1
        var selectionArray = Array(selectionIndexPaths)
        
        selectionArray.sort { (path1, path2) -> Bool in
            return path1.compare(path2) == .orderedDescending
        }
        for itemIndexPath in selectionArray {
            // 2
            imageDirectoryLoader.removeImageAtIndexPath(indexPath: itemIndexPath)
        }
        
        // 3
        collectionView.deleteItems(at: selectionIndexPaths)
    }

    

    private let itemSize:NSSize = NSSize(width: 160, height: 140)
    private let lineSpace:CGFloat = 20.0;

    //MARK: - select
    
    

    
}

//MARK: - register drag && drop
extension ViewController
{
    private func registDragAndDrop(){
        collectionView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
        //对内部程序
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        //对外部程序
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
    }
    

    
    @objc func selectItem(at indexPath:IndexPath)
    {
        print("select at \(indexPath)")
           
        let item = collectionView.item(at: indexPath)

        guard let collectionViewItem =  item as? CollectionViewItem else {
            return
        }
        var selectArray = collectionView.selectionIndexPaths
        if(selectArray.contains(indexPath))
        {
            selectArray.remove(indexPath)
            collectionViewItem.setHighlight(selected: false)
        }else
        {
            selectArray.insert(indexPath)
            collectionViewItem.setHighlight(selected: true)
        }

        collectionView.selectionIndexPaths = selectArray

    }
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

        collectionViewItem.target = self
        collectionViewItem.action = #selector(selectItem(at:))
        collectionViewItem.indexPath = indexPath

        return collectionViewItem
    }
    
    //视图控制
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView
    {
        let identifier: String = kind == NSCollectionView.elementKindSectionHeader ? "HeadView" : "CollectionViewItem"
        let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), for: indexPath)
        // 2
        if kind == NSCollectionView.elementKindSectionHeader {
            let headerView = view as! HeadView
            headerView.sectionTitle.stringValue = "Section \(indexPath.section)"
            let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(section: indexPath.section)
            headerView.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        }
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
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize
    {
//        return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
        return NSZeroSize
    }
}


//MARK: - NSCollectionViewDelegate

extension ViewController:NSCollectionViewDelegate
{
    
    //MARK: 选择事件
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>)
    {
        highlightItems(selected: true, atIndexPaths: indexPaths)
    }
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>)
    {
        highlightItems(selected: false, atIndexPaths: indexPaths)
    }
    
    
    //MARK: 拖拽
    // 是否允许Drag
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    //Drag PasteBoard 记录信息
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        let imageFile:ImageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath as NSIndexPath)
        
        return imageFile.url
    }
    
    // 记录开始拖动时的 indexPaths
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        indexPathsOfItemsBeingDragged = indexPaths
    }
    
    // 接收
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation{
        if proposedDropOperation.pointee == .on{
            proposedDropOperation.pointee = .before
        }
        if indexPathsOfItemsBeingDragged == nil{
            return NSDragOperation.copy
        }else{
            return NSDragOperation.move
        }
    }
    
     
    
    
    // 1
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
   
      if indexPathsOfItemsBeingDragged != nil {
        // 2
        for currentIndex in indexPathsOfItemsBeingDragged{
            let indexPathOfFirstItemBeingDragged = currentIndex
            var toIndexPath: NSIndexPath
            if indexPathOfFirstItemBeingDragged.compare(indexPath as IndexPath) == .orderedAscending {
              toIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
            } else {
              toIndexPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section)
            }
            // 3
            imageDirectoryLoader.moveImageFromIndexPath(indexPath: indexPathOfFirstItemBeingDragged, toIndexPath: toIndexPath)
            // 4
            collectionView.moveItem(at: indexPathOfFirstItemBeingDragged, to: toIndexPath as IndexPath)
        }
       
      } else {
        // 5
        var droppedObjects = Array<NSURL>()
        draggingInfo.enumerateDraggingItems(options: NSDraggingItemEnumerationOptions.concurrent, for: collectionView, classes: [NSURL.self], searchOptions: [NSPasteboard.ReadingOptionKey.urlReadingFileURLsOnly : NSNumber(value: true)]) { (draggingItem, idx, stop) in
          if let url = draggingItem.item as? NSURL {
            droppedObjects.append(url)
          }
        }
        // 6
        insertAtIndexPathFromURLs(urls: droppedObjects, atIndexPath: indexPath as NSIndexPath)
      }
      return true
    }
    
    // 7
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
      indexPathsOfItemsBeingDragged = nil
    }

}


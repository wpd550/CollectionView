//
//  HeadView.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/16.
//

import Cocoa
import AppKit

class HeadView: NSView{
    @IBOutlet weak var sectionTitle:NSTextField!
    @IBOutlet weak var imageCount:NSTextField!
//    @IBOutlet weak var  CollapseButton: NSButton!
    @IBOutlet unowned(unsafe) var sectionCollapseButton: NSButton?
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(calibratedWhite: 0.8, alpha: 0.2).set()
        let bzPath = NSBezierPath(roundedRect: dirtyRect, xRadius: 2, yRadius: 2)
        bzPath.fill()
       
    }
    
    
    
}

extension HeadView:NSCollectionViewSectionHeaderView
{
  
    
}

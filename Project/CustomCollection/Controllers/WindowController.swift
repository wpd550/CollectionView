//
//  WindowController.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/15.
//

import Cocoa

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window,let screen = NSScreen.main{
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width/2.0, height: screenRect.height/2.0),display: true)
        }
        
    }
}

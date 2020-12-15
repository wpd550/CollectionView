//
//  ImageFile.swift
//  CustomCollection
//
//  Created by dong wu on 2020/12/15.
//

import Cocoa

class ImageFile {
    private(set) var thumbnail:NSImage?
    private(set) var fileName:String
    
    init(url:NSURL) {
        if let name = url.lastPathComponent {
          fileName = name
        } else {
          fileName = ""
        }
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL! as CFURL, nil)
        if let imageSource = imageSource {
          guard CGImageSourceGetType(imageSource) != nil else { return }
          thumbnail = getThumbnailImage(imageSource: imageSource)
        }
    }
    
    
    func getThumbnailImage(imageSource: CGImageSource)->NSImage?{
        let thumbnailOptions = [
            String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
            String(kCGImageSourceThumbnailMaxPixelSize): 160
        ] as [String : Any]
        guard let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource,0,thumbnailOptions as CFDictionary) else
        {
            return nil;
        }
        
        return NSImage(cgImage:thumbnailRef,size: NSSize.zero)
    }
    
}

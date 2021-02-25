//
//  NSMenuItem.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//

import Foundation
import AppKit

extension NSMenuItem {
    
    convenience init(title: String, target: AnyObject?, action: Selector, image: String? = nil, key: String? = nil) {
        self.init()
        self.title = title
        self.target = target
        self.action = action
        
        if let image = image {
            self.image = NSImage(systemSymbolName: image, accessibilityDescription: title)
        }
        
        if let hotKey = key {
            self.keyEquivalent = hotKey
            self.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: UInt(Int(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue)))
        }
    }
    
}

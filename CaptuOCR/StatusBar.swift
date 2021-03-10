//
//  StatusBar.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//
import AppKit
import Cocoa
import SwiftUI

class StatusBar {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    let popover = NSPopover()
    
    let last = NSMenuItem()
    
    init() {
        let icon = NSImage(named: NSImage.Name("icons8-text-16"))
        icon?.isTemplate = true
        statusItem.button?.image = icon
        statusItem.menu = menu
        buildMenu()
    }
    
    private func buildMenu() {
        menu.addItem(NSMenuItem(title: "Take Image", target: self, action: #selector(capturePic4Txt), image: "qrcode.viewfinder", key: "c"))
        menu.addItem(NSMenuItem(title: "Select Image", target: self, action: #selector(selectPic4Txt), image: "photo"))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "History", target: self, action: #selector(showHistory), image: "list.dash", key: "h"))

        
        last.title = "last"
        menu.addItem(last)
        
        menu.addItem((NSMenuItem(title: "Quit", target: self, action: #selector(quit), image: "xmark", key: "q")))
    }
    
    /// Abre el selector de archivos para optener una imagen
    /// la cual se procesara en el OCR
    @objc func selectPic4Txt() {
        let dialog = NSOpenPanel()
        dialog.title = "Image"
        dialog.directoryURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["png", "jpg", "bmp"]

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let result = dialog.url {
                recognizepic(in: result)
            }
        }
    }
    
    /// Ejecuta la app ScreenCapture y la imagen la procesa en OCR
    @objc func capturePic4Txt() {
        guard let path = ScreenCapture.capturePic() else {
            return
        }
        let url = URL(fileURLWithPath: path)
        recognizepic(in: url)
    }

    @objc func showHistory() {
        
        let records = Array(HistoryService.findAll().reversed())
        
        let vc = NSHostingController(rootView: HistoryView(records: records))
        popover.behavior = .transient
        popover.contentViewController = vc
            
        
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
       

//        let windowController = HistoryWindowController(windowNibName: NSNib.Name("HistoryWindowController"))
//        windowController.showWindow(self)
        
    }
    
    
    @objc
    func quit() {
        NSApplication.shared.terminate(self)
    }
    
    private func recognizepic(in url: URL) {
      
        guard
            let image = NSImage(contentsOf: url) else {
            return
        }
        
        RecognizeText.text(in: image) { result in
            switch result {
            case .success(let text):
                self.showResult(for: text, with: image)
                    
            case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func showResult(for text: String, with image: NSImage) {
        
        let vc = RecognizeBoxViewController()
        
        vc.text = text
        vc.image = image
        
        popover.behavior = .transient
        popover.contentViewController = vc
        
        let record = HistoryRecord()
        record.text = text
        
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        record.imageBase64 = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        HistoryService.add(record)
        
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

}

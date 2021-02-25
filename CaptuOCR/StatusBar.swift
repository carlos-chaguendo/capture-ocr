//
//  StatusBar.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//
import AppKit
import Cocoa

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
        
        last.title = "last"
        menu.addItem(last)
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
        
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

}

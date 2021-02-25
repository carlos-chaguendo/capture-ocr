//
//  RecognizeBoxViewController.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//

import Cocoa

class RecognizeBoxViewController: NSViewController {
    
    @IBOutlet var layout: NSView!
    @IBOutlet var vLine: NSBox!
    @IBOutlet var vLineCenter: NSLayoutConstraint!
    @IBOutlet var imageArea: NSImageView!
    @IBOutlet var textArea: NSTextView!
    @IBOutlet var imgHeight: NSLayoutConstraint!
    @IBOutlet var imgWidth: NSLayoutConstraint!
    
    
    public var image: NSImage!
    public var text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageArea.image = image
        textArea.string = text
    }
    
}

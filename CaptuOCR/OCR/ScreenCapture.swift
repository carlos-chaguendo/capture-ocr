//
//  ScreenCapture.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//

import Foundation

class ScreenCapture {
    
    static func capturePic() -> String? {
        let destinationPath =  NSTemporaryDirectory().appending(UUID().uuidString).appending(".png") //"/tmp/\(UUID().uuidString).png"

        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", destinationPath]
        task.launch()
        task.waitUntilExit()
        var notDir = ObjCBool(false)
        return FileManager.default.fileExists(atPath: destinationPath, isDirectory: &notDir)
            ? destinationPath
            : nil
    }
    
}

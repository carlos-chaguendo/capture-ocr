//
//  RecognizeText.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//

import Foundation
import Vision
import AppKit

class RecognizeText {
    
    typealias Handler =  (Result<String, Error>) -> Void
    
    class func text(in image: NSImage , handle completionHandler: @escaping Handler) -> Void {
        DispatchQueue.global(qos: .userInteractive).async {
          
            guard let cgimage = image.asCGImage() else {
                completionHandler(.failure(NSError(domain: "recognize", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey: "NOt CG Image"])))
                return
            }

            do {
                try VNImageRequestHandler(cgImage: cgimage, options: [:]).perform([
                    VNRecognizeTextRequest { request, _ in

                        guard let observations = request.results as? [VNRecognizedTextObservation] else {
                            preconditionFailure()
                        }

                        observations.forEach {
                            print("> ", [$0.bottomLeft, $0.topLeft])
                        }

                        let recognizedText = observations
                            .map { $0.topCandidates(1) }
                            .flatMap { $0 }
                            .map { $0.string }
                            .joined(separator: "\n")

                        DispatchQueue.main.async {
                            completionHandler(.success(recognizedText))
                        }
     
                    }])
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                
            }
        }
    }
}

extension NSImage {
    
    func asCGImage() -> CGImage? {
        var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        return self.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
      }
    
}


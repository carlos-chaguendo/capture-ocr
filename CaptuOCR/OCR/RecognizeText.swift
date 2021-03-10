//
//  RecognizeText.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 24/02/21.
//

import Foundation
import Vision
import AppKit

extension FloatingPoint {
    /// Rounds the double to decimal places value
    public func rounded(toPlaces places: Int) -> Self {
        let divisor = Self(Int(pow(10.0, Double(places))))
        return (self * divisor).rounded() / divisor
    }
}

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
                            print("> ", $0.topLeft.x.rounded(toPlaces: 3) )
                        }

                        let recognizedText = observations
                            .map { $0.topCandidates(1) }
                            .flatMap { $0 }
                            .map { $0.string }
                            .joined(separator: "\n")
                        
                        let recognizedText2 = observations
                            .map { ($0.topLeft.x, $0.topCandidates(1)[0]) }
                       
                            .map { leftSpaced($0.0) + $0.1.string }
                            .joined(separator: "\n")
                        
                        print("recognizedText2", recognizedText2)

                        DispatchQueue.main.async {
                            completionHandler(.success(recognizedText2))
                        }
     
                    }])
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                
            }
        }
    }
    
    class func leftSpaced(_ x: CGFloat) -> String {
      let n = (x * 10 ).rounded(toPlaces: 4) * 10
    
       return "".padding(toLength: Int(n), withPad: " ", startingAt: 0)
   }

}

extension NSImage {
    
    func asCGImage() -> CGImage? {
        var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        return self.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
      }
    
}


//
//  ImageAnalyzerService.swift
//  Module-Example
//
//  Created by Marcio Fetter on 10/01/21.
//

import UIKit
import CoreML
import Vision

protocol ImageAnalyzerService {
    func analyzeImage(image: UIImage, navigationController: UINavigationController, failure: @escaping (_ error: String) -> Void)
}

class ImageAnalyzer: ImageAnalyzerService {
    
    func analyzeImage(image: UIImage, navigationController: UINavigationController, failure: @escaping (_ error: String) -> Void) {
        
        guard let ciImage = CIImage(image: image) else {
            failure("couldn't convert UIImage to CIImage")
            return
        }
        
        guard let model = try? VNCoreMLModel(for: CNNEmotions(configuration: MLModelConfiguration()).model) else {
            failure("can't load CNNEmotions ML model")
            return
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { request, error in
            if let _error = error {
                failure(_error.localizedDescription)
            } else if let results = request.results as? [VNClassificationObservation] {
                DispatchQueue.main.async {
                    let vc = AnalysisResultViewController(image: image, results: results)
                    //let analysisDetailViewController = AnalysisDetailViewController(image: image, results: results)
                    navigationController.pushViewController(vc, animated: true)
                }
            }
        }

        // Run the Core ML CNNEmotions classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInteractive).async {
          do {
            try handler.perform([request])
          } catch {
            failure(error.localizedDescription)
          }
        }
    }
}


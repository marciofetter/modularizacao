//
//  AnalysisResultViewController.swift
//  Module-Example
//
//  Created by Marcio Fetter on 13/01/21.
//

import UIKit
import Vision

class AnalysisResultViewController: UIViewController {
    
    @IBOutlet weak var uiResultImageView: UIImageView!
    @IBOutlet weak var uiResulLabel: UILabel!
    @IBOutlet weak var uiConfidenceLabel: UILabel!
    
    private var results: [VNClassificationObservation]
    private var imageToLoad: UIImage
    
    init(image: UIImage, results: [VNClassificationObservation]) {
        self.imageToLoad = image
        self.results = results
        super.init(nibName: "AnalysisResultViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResults()
    }
    
    //MARK: - Methods
    private func setupResults() {
        uiResultImageView.image = imageToLoad
        if let firstResult = results.first {
            uiResulLabel.text = firstResult.identifier
            uiConfidenceLabel.text = "\(Int(firstResult.confidence * 100))% de confiança"
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

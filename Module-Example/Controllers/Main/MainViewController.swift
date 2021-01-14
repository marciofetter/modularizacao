//
//  ViewController.swift
//  Module-Example
//
//  Created by Marcio Fetter on 10/01/21.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Visual Elements
    private let imageScene: UIImageView

    private let selectImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(callPickerImage), for: .touchUpInside)
        return button
    }()
    
    private let analyzeImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.cornerRadius = 14
        button.setTitle("Analyze Image", for: .normal)
        button.addTarget(self, action: #selector(analyseImage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Propeties
    private let analizer: ImageAnalyzerService
    
    private var imageToAnalyle: UIImage? {
        didSet {
            if let image = imageToAnalyle {
                imageScene.image = image
            } else if let image = UIImage(named: "Image-placeholder") {
                imageScene.image = image
            }
        }
    }
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    //MARK: - Life Cycle
    init(analizer: ImageAnalyzerService = ImageAnalyzer()) {
        self.analizer = analizer
        self.imageScene = UIImageView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageToAnalyle = nil
    }
    
    //MARK: - Methods
    @objc private func callPickerImage() {
    
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(from: .camera)
            
          })
          alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) {(action: UIAlertAction) in
            self.selectPicture(from: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func selectPicture(from sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func analyseImage() {
        guard let image = imageToAnalyle, let nav = navigationController else { return }
        analizer.analyzeImage(image: image, navigationController: nav) { (error) in
            print(error)
        }
    }
}

//MARK: - ImagePicker delegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageToAnalyle = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Layout Configuration
extension MainViewController: ViewConfiguration {
    
    func buildViewHierarchy() {
        view.addSubview(imageScene)
        view.addSubview(selectImageButton)
        view.addSubview(analyzeImageButton)
    }
    
    func setupConstraints() {
        imageScene.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(imageScene.snp.width)
        }
        selectImageButton.snp.makeConstraints { (make) in
            make.top.right.left.height.equalTo(imageScene)
        }
        analyzeImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(selectImageButton.snp.bottom).offset(30)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).inset(20)
            make.height.equalTo(44)
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        navigationItem.title = "Sentimental Analyzer"
    }
}

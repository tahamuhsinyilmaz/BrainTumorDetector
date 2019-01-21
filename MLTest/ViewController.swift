//
//  ViewController.swift
//  MLTest
//
//  Created by MAC on 14.11.2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var resultLabel:UILabel!
    var selectedImage = CIImage()
    
    func recognizeImage(image: CIImage) {
        resultLabel.text = "I'm investigating..."
        if let model = try? VNCoreMLModel(for: gliompitu94().model) {
            let request = VNCoreMLRequest(model: model, completionHandler: { (vnrequest, error) in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    let topResult = results.first
                    DispatchQueue.main.async {
                        let confidenceRate = (topResult?.confidence)! * 100
                        let rounded = Int (confidenceRate * 100) / 100
                        self.resultLabel.text = "\(rounded)% it's \(topResult?.identifier ?? "Anonymous")"
                    }
                }
            })
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Err :(")
                }
            }
        }
    }
    
    @IBAction func takePhotoButton(sender: Any){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let ciImage = CIImage(image: imageView.image!) {
            self.selectedImage = ciImage
        }
        recognizeImage(image: selectedImage)
    }

    
}


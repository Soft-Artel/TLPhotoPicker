//
//  PreviewPhoto.swift
//  TLPhotoPicker
//
//  Created by Мурат Камалов on 09.04.2020.
//  Copyright © 2020 wade.hawk. All rights reserved.
//

import UIKit


public protocol PhotoEditorDelegate: class{
    func openPhotoEditor(with image: UIImage, complition: (Bool) -> ())
}


@available(iOS 13.0, *)
class PreviewPhoto: UIViewController{
    
    let previewImage = UIImageView()
    
    var image: UIImage!
    
    let editBtn = UIButton()
    let usePhotoBtn = UIButton()
    let retakeBtn = UIButton()
    
    var  complition: ((Bool) -> ())!
    
    static func show(with parentVC: UIViewController, and image: UIImage, complition: @escaping (Bool) -> ()){
        let preview = PreviewPhoto()
        preview.image = image
        preview.complition = complition
        preview.previewImage.image = image
        parentVC.present(preview, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp(){
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.previewImage)
        self.view.addSubview(self.editBtn)
        self.view.addSubview(self.usePhotoBtn)
        self.view.addSubview(self.retakeBtn)
        
        self.previewImage.translatesAutoresizingMaskIntoConstraints = false
        self.usePhotoBtn.translatesAutoresizingMaskIntoConstraints = false
        self.retakeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.editBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let heightInPoints = self.previewImage.image?.size.height
        let heightInPixels = heightInPoints! * self.previewImage.image!.scale

        let widthInPoints = self.previewImage.image?.size.width
        let widthInPixels = widthInPoints! * self.previewImage.image!.scale
        
        let arrowRight = TLBundle.podBundleImage(named: "ArrowRight")?.withRenderingMode(.alwaysTemplate)
        
        self.previewImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.previewImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        if heightInPixels > widthInPixels{
            let scale = widthInPixels / heightInPixels
            
            self.previewImage.topAnchor.constraint(equalTo: self.editBtn.bottomAnchor,constant: 20).isActive = true
            self.previewImage.bottomAnchor.constraint(equalTo: self.usePhotoBtn.topAnchor, constant: -20).isActive = true
            self.previewImage.widthAnchor.constraint(equalTo: self.previewImage.heightAnchor, multiplier: scale).isActive = true
        }
        
        self.editBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.editBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.editBtn.widthAnchor.constraint(equalToConstant: 32).isActive = true
        self.editBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        let imageEdit = TLBundle.podBundleImage(named: "EditBtn")
        self.editBtn.setImage(imageEdit, for: .normal)
        self.editBtn.addTarget(self, action: #selector(self.editPhoto), for: .touchUpInside)
        self.editBtn.tintColor = .red
        
        self.usePhotoBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.usePhotoBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        self.usePhotoBtn.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.usePhotoBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.usePhotoBtn.setImage(arrowRight, for: .normal)
        self.usePhotoBtn.tintColor = .red
        
        self.usePhotoBtn.addTarget(self, action: #selector(self.takePhoto), for: .touchUpInside)
        
        self.retakeBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.retakeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        self.retakeBtn.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.retakeBtn.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.retakeBtn.setImage(arrowRight, for: .normal)
        self.retakeBtn.tintColor = .red
        
        self.retakeBtn.addTarget(self, action: #selector(self.retake), for: .touchUpInside)
        
        self.retakeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
    }
    
    @objc func editPhoto(){
        guard let delegate = TLPhotosPickerViewController.delegateEditor else { return }
        delegate.openPhotoEditor(with: image, complition: self.complition)
    }
    
    @objc func takePhoto(){
        self.complition(false)
    }
    
    @objc func retake(){
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  PreviewPhoto.swift
//  TLPhotoPicker
//
//  Created by Мурат Камалов on 09.04.2020.
//  Copyright © 2020 wade.hawk. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class PreviewPhoto: UIViewController{
    
    let previewImage = UIImageView()
    
    var image: UIImage!
    
    let editBtn = UIButton()
    let usePhotoBtn = UIButton()
    let retakeBtn = UIButton()
    
    static var sharedPreviewPhoto: PreviewPhoto? = nil
    
    var  complition: ((Bool) -> ())!
    
    static func show(with parentVC: UIViewController, and image: UIImage, complition: @escaping (Bool) -> ()){
        let preview = PreviewPhoto()
        preview.image = image
        preview.complition = complition
        preview.previewImage.image = image
        PreviewPhoto.sharedPreviewPhoto = preview
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
        
        let arrowRight = TLBundle.podBundleImage(named: "ArrowRight")
        
        self.previewImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.previewImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        if heightInPixels > widthInPixels{
            let scale = widthInPixels / heightInPixels
            
            self.previewImage.topAnchor.constraint(greaterThanOrEqualTo: self.editBtn.bottomAnchor, constant: 20).isActive = true//constraint(equalTo: self.editBtn.bottomAnchor,constant: 20).isActive = true
            self.previewImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
            self.previewImage.widthAnchor.constraint(equalTo: self.previewImage.heightAnchor, multiplier: scale).isActive = true
        }
        
        self.editBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.editBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.editBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.editBtn.widthAnchor.constraint(equalTo: self.editBtn.heightAnchor, multiplier: 32/26).isActive = true
        let imageEdit = TLBundle.podBundleImage(named: "EditBtn")
        self.editBtn.setImage(imageEdit, for: [])
        self.editBtn.addTarget(self, action: #selector(self.editPhoto), for: .touchUpInside)
                
        self.usePhotoBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.usePhotoBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        self.usePhotoBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.usePhotoBtn.heightAnchor.constraint(equalTo: self.usePhotoBtn.widthAnchor, multiplier: 18/10).isActive = true
        self.usePhotoBtn.setImage(arrowRight, for: [])
        self.usePhotoBtn.contentEdgeInsets = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        
        self.usePhotoBtn.addTarget(self, action: #selector(self.takePhoto), for: .touchUpInside)
        
        self.retakeBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.retakeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        self.retakeBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.retakeBtn.heightAnchor.constraint(equalTo: self.usePhotoBtn.widthAnchor, multiplier: 18/10).isActive = true
        self.retakeBtn.setImage(arrowRight, for: [])
        self.retakeBtn.contentEdgeInsets = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        
        self.retakeBtn.addTarget(self, action: #selector(self.retake), for: .touchUpInside)
        
        self.retakeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
    }
    
    @objc func editPhoto(){
        guard let delegate = TLPhotosPickerViewController.delegateEditor else { return }
//        delegate.openPhotoEditor(with: image, parentVC: self, complition: self.complition)
    }
    
    @objc func takePhoto(){
        self.complition(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func retake(){
        self.dismiss(animated: true, completion: nil)
    }
}

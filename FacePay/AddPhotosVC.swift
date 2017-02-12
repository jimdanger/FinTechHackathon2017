//
//  AddPhotosVC.swift
//  FacePay
//
//  Created by James Wilson on 2/12/17.
//  Copyright © 2017 jimdanger. All rights reserved.
//

import UIKit


class AddPhotosVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let picker:UIImagePickerController = UIImagePickerController()

    // hookup photo outlets 


    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddPhotosVC viewDidLoad")
        // Do any additional setup after loading the view.
        picker.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pickPhotoFromLibrary(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        //picker.popoverPresentationController?.barButtonItem = button
    }

    func shootPHoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }


    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }


    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //myImageView.contentMode = .scaleAspectFit //3
        //myImageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


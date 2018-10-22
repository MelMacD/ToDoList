//
//  ListViewController.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-15.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit
import os.log

class ListViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
    }

    //MARK: UITextFieldDelegate test

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // executes after done editing, can disable save button or not
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Executes on user tapping text field to edit, can indicate to disable save button or not
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        pictureImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        showAlertToPickImage()
    }
    
    @IBAction func scaleImageWhenPinched(_ sender: UIPinchGestureRecognizer) {
    }
    
    //MARK: Custom Functions
    
    func selectImageFromLibrary() {
        // Hide the keyboard.
        titleTextField.resignFirstResponder()
        // one for notes text field too
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func selectImageWithCamera() {
        // Hide the keyboard.
        titleTextField.resignFirstResponder()
        // one for notes text field too
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be taken with the camera
        imagePickerController.sourceType = .camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func showAlertToPickImage() {
        let alert = UIAlertController(title: "How would you like to set the image?", message: "You can either choose from the image gallery or take a picture.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Use Gallery", style: .default, handler: { action in self.selectImageFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { action in
            self.selectImageWithCamera()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }

}


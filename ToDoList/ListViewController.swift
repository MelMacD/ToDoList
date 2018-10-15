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
    @IBOutlet weak var notesTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        notesTextView.delegate = self
    }

    //MARK: UITextFieldDelegate

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
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        titleTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .savedPhotosAlbum // be able to either take photo from album or take new photo
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}


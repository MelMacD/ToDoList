//
//  ListViewController.swift
//  ToDoList
//
// Do not crop image, save in image model the original image, zoom level, and center, view or scrollview
//TODO: - fix notes so has way to dismiss keyboard
//      - find images to use for priority
//      - implement missing elements
//      - register gestures to allow for zooming and panning of an image
//      - add Image.swift class and have that information persist
//      - implement showing and hiding of elements
//
//  Created by Melanie MacDonald on 2018-10-15.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit
import os.log

class ListViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    //MARK: Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateEnteredLabel: UILabel!
    @IBOutlet weak var dateEnteredValue: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    // Outlets to control zooming and panning of an image
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    
    
    // This value is either passed by 'ListItemTableViewController' in 'prepare(for:sender:)' or constructed as part of adding a new meal
    var listItem: ListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        notesTextView.delegate = self
        
        // Create a black border around the notes text view
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor

        // Set zooming constraints
        imageScrollView.zoomScale = 1.0
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        imageScrollView.delegate = self
        
        // Set up views if editing an existing Item.
        if let listItem = listItem {
            navigationItem.title = listItem.title
            titleTextField.text = listItem.title
            pictureImageView.image = listItem.photo
            notesTextView.text = listItem.notes
            dateEnteredValue.text = listItem.dateEntered
            doHideDateEntered(flag: false)
        } else {
            doHideDateEntered(flag: true)
        }
        
        // Enable the save button only if there is a valid title
        updateSaveButtonState()
    }

    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // executes after done editing, can disable save button or not
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // TODO connect the save button being enabled or disabled to every required field, as necessary
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Executes on user tapping text field to edit, can indicate to disable save button or not
        saveButton.isEnabled = false
    }
    
    //MARK: UITextViewDelegate // need to have something like a "done" button on view
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        // Hide the keyboard
        textView.resignFirstResponder()
        
        return true
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
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push), this view controller needs to be dismissed differently
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddItemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ListViewController is not inside a navigation controller")
        }
    }
    
    // Configures a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Confgure the destination view controller only when save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = titleTextField.text ?? ""
        let photo = pictureImageView.image
        let notes = notesTextView.text ?? ""
        var dateEntered = dateEnteredValue.text ?? ""
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddItemMode {
            dateEntered = convertDateToString(date: Date())
        }
        
        // Set the meal to be passed to ListItemTableViewController after the unwind seque
        listItem = ListItem(title: title, photo: photo, notes: notes, dateEntered: dateEntered)
    }
    
    //MARK: Actions
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        showAlertToPickImage()
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

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func doHideDateEntered(flag: Bool) {
        dateEnteredLabel.isHidden = flag
        dateEnteredValue.isHidden = flag
    }
    
    func viewForZooming(in imageScrollView: UIScrollView) -> UIView? {
        return pictureImageView
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}

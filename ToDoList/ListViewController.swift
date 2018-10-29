//
//  ListViewController.swift
//  ToDoList
//
//  Created by Melanie MacDonald on 2018-10-15.
//  Copyright © 2018 Melanie MacDonald. All rights reserved.
//

import UIKit
import os.log

class ListViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateEnteredLabel: UILabel!
    @IBOutlet weak var dateEnteredValue: UILabel!
    @IBOutlet weak var dateDuePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priorityPicker: UIPickerView!
    // Outlets to control zooming and panning of an image
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    let dateDueOptions = ["", "Select Date", "Immediately"]
    let priorityOptions = ["Low", "Medium", "High"]
    
    // This value is either passed by 'ListItemTableViewController' in 'prepare(for:sender:)' or constructed as part of adding a new meal
    var listItem: ListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        notesTextView.delegate = self
        dateDuePicker.delegate = self
        dateDuePicker.dataSource = self
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        
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
            pictureImageView.image = listItem.photo.photo
            imageScrollView.zoomScale = listItem.photo.scaleAmount
            imageScrollView.contentOffset.x = listItem.photo.centerX
            imageScrollView.contentOffset.y = listItem.photo.centerY
            notesTextView.text = listItem.notes
            dateEnteredValue.text = listItem.dateEntered
            doHideDateEntered(flag: false)
            priorityPicker.selectRow(listItem.priority, inComponent: 0, animated: true)
            displayDueDateValue(dateDue: listItem.dateDue)
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
    
    //MARK: Picker Handlers
    func numberOfComponents(in dateDuePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return dateDueOptions.count
        }
        else {
            return priorityOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return "\(dateDueOptions[row])"
        }
        else{
            return "\(priorityOptions[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1 && row == 1){
            doHideDatePicker(flag: false)
        }
        else if (pickerView.tag == 1){
            doHideDatePicker(flag: true)
        }
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
        let photo = Image(photo: pictureImageView.image!, scaleAmount: imageScrollView.zoomScale, centerX: determineCenter().x, centerY: determineCenter().y)
        let notes = notesTextView.text ?? ""
        var dateEntered = dateEnteredValue.text ?? ""
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddItemMode {
            dateEntered = convertDateToString(date: Date())
        }
        let priority = priorityPicker.selectedRow(inComponent: 0)
        
        let dateDue = getDueDateValue(selection: dateDuePicker.selectedRow(inComponent: 0))
        
        // Set the meal to be passed to ListItemTableViewController after the unwind seque
        
        listItem = ListItem(title: title, photo: photo!, notes: notes, dateEntered: dateEntered, dateDue: dateDue, priority: priority)
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
    
    func doHideDatePicker(flag: Bool) {
        datePicker.isHidden = flag
    }
    
    func determineCenter() -> CGPoint{
        var newX = 0.0
        var newY = 0.0
        if (imageScrollView.contentOffset.x > 0) {
            newX = Double((imageScrollView.contentOffset.x))
        }
        if (imageScrollView.contentOffset.y > 0) {
            newY = Double((imageScrollView.contentOffset.y))
        }
        return CGPoint(x: newX, y: newY)
    }
    
    func getDueDateValue(selection: Int) -> Any {
        if selection == 0 {
            return 0
        }
        else if selection == 1 {
            return datePicker.date
        }
        else {
            return "ASAP"
        }
    }
    
    func displayDueDateValue(dateDue: Any) {
        if dateDue is Int && dateDue as! Int == 0 {
            dateDuePicker.selectRow(0, inComponent: 0, animated: true)
        }
        else if dateDue is Date {
            dateDuePicker.selectRow(1, inComponent: 0, animated: true)
            datePicker.setDate(dateDue as! Date, animated: true)
            doHideDatePicker(flag: false)
        }
        else if dateDue is String {
            dateDuePicker.selectRow(2, inComponent: 0, animated: true)
        }
        else {
            os_log("The due date could not be parsed", log: OSLog.default, type: .error)
        }
    }
}
// TODO: Fix weird navigation
/*
 1. Fix appearance of tabbed view
 2. Fix auto-layout contraints so it is truly adaptive
 3. Provide a way to dismiss the notes keyboard
 */

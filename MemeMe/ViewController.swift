//
//  ViewController.swift
//  MemeMe from MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 4/29/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewToolbar: UIToolbar!
    @IBOutlet weak var viewNavBar: UINavigationBar!
        
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //Extra credit attempt: Added free custom font BebasNeue to the project
    //in lieu of Impact font(serious investment).
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "BebasNeueBold", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0),
    ]
    
    // Meme detail will set these, if editing previously made meme.
    var reEditingMeme = false
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Only if re-editing meme via edit button of MemeDetailVC.
        if reEditingMeme {
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate

            topTextField.text = appDelegate.memes[index].topText
            bottomTextField.text = appDelegate.memes[index].bottomText
            self.imagePickerView.image = appDelegate.memes[index].originalImage
        } else {
        
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
        }
        
        topTextField.textAlignment =  .Center
        bottomTextField.textAlignment = .Center
        //just added 5.12.15
        topTextField.borderStyle = .None
        bottomTextField.borderStyle = .None
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.delegate = self
        bottomTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeFromKeyboardHideNotifications()
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if (textField.text == "TOP") || (textField.text == "BOTTOM"){
            
            textField.text = ""
        }
    }
        
    func textFieldShouldReturn(textField:UITextField)->Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            // Original code below
            //self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.view.frame.origin.y = -(getKeyboardHeight(notification))
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
      
        if bottomTextField.isFirstResponder() {
            
            // Origin point of the frame is (0,0).
            // Height is always zero at its default position.
            self.view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Present imagepicker.
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Capture image in imagePickerView and dismiss imagePicker.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navbar
        viewToolbar.hidden = true
        viewNavBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        viewToolbar.hidden = false
        viewNavBar.hidden = false
        
        return memedImage
    }

    @IBAction func showActivityVC(sender: UIBarButtonItem) {
        
        let image = generateMemedImage()

        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // When complete save image; dismiss ActivityVC.
        
        controller.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                self.save(image)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func ShowSentMemes(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func save(image: UIImage) {
        
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText:bottomTextField.text!,
            originalImage: self.imagePickerView.image, memedImage: image)
        
        //Update data model (memes).
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if reEditingMeme {
            appDelegate.memes[index] = meme
            reEditingMeme = false
            
            // Get index of meme to be re-edited when edit button of MemeDetailVC pressed. Update MemeDetailVC with the current meme.
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
            controller.index = index
            
        } else {
            appDelegate.memes.append(meme)
        }
    }
}


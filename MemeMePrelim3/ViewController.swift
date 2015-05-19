//
//  ViewController.swift
//  MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 4/29/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
/***trying in separate file
struct Meme {
    var topText = ""
    var bottomText = ""
    var originalImage: UIImage?
    var memedImage: UIImage?
}
***/

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0),
        //TODO: Fill in appropriate Float
    ]
    
    //var memedImage: UIImage
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //topTextField.autocapitalizationType = .AllCharacters
        
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment =  .Center
        bottomTextField.textAlignment = .Center
        //just added 5.12.15
        topTextField.borderStyle = .None
        bottomTextField.borderStyle = .None

        
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        
        
        //topTextField.tintColor = UIColor.blackColor()
        
        /***
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.borderStyle = UITextBorderStyle.None
        topTextField.opaque = false
        topTextField.textColor = UIColor.whiteColor()
        println("topTextField = \(topTextField)")
        ***/
       
        
        /***
        
        ***/
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeFromKeyboardHideNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        println("Inside textFieldDidBeginEditing")
        println("textField is \(textField)")
        println()
        
        if (textField.text == "TOP") || (textField.text == "BOTTOM"){
            
            textField.text = ""
        }
        
        //textField.autocapitalizationType = .AllCharacters
    }
    
    
    func textFieldShouldReturn(textField:UITextField)->Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
      
        if bottomTextField.isFirstResponder() {
            
            self.view.frame.origin.y += getKeyboardHeight(notification)
           
        }
        //self.view.endEditing(true)

        //self.view.frame.origin.y += getKeyboardHeight(notification)
        
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
    
    /***
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
****/
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
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
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }

    @IBAction func showActivityVC(sender: UIBarButtonItem) {
        
        
        let image = generateMemedImage()
        //save()

        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        //when complete save, dismiss VC, and segue to Sent Memes
        controller.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("ShowSentMemes", sender: self)
            }
        }
        self.presentViewController(controller, animated: true, completion: nil)

    }
/***old code-?worked about the same except for performSegueWithIdentifier

        presentViewController(controller, animated: true, completion: nil)
        save()
            }
***/
    

    
    
    func save() {
        //Create the meme
        
        var meme = Meme(topText: topTextField.text!, bottomText:bottomTextField.text!,
            originalImage: self.imagePickerView.image, memedImage: generateMemedImage())
        

        println ("meme is \(meme)")
        println ("topText is \(meme.topText)")
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
         
         /*****/
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    //TODO:  Refactor L2 code to create function to segue to
    //Tab Bar VC.  Be sure to give Tab Bar Vc it a storyboard ID
    //and Class name.?Won't need to pass the data either.
    //It will need to be called after ActivityVC completes.
   
//IBAction func rollTheDice() {
//// Get the DiceViewController
//
//var controller: DiceViewController
//
//controller = self.storyboard?.instantiateViewControllerWithIdentifier("DiceViewController") as! DiceViewController
//
//// Set the two values to random numbers from 1 to 6
//controller.firstValue = self.randomDiceValue()
//controller.secondValue = self.randomDiceValue()
//
//// Present the view Controller
//self.presentViewController(controller, animated: true, completion: nil)
//}

    
//    From BondVillains with tabs for detail view display
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//        
//    }


}


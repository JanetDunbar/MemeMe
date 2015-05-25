//
//  MemeDetailVC.swift
//  MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/17/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    //var meme = Meme()
    
    // Index of meme to display
    var index = -1
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Store our AppDelegate for access to the memes
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("MemeDetailVC: viewWillAppear() called")
        print("meme.topText = \(appDelegate.memes[index].topText)")
        
        // Do any additional setup after loading the view.
        self.imageView!.contentMode = .ScaleAspectFit
        self.imageView!.image = appDelegate.memes[index].memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func startOver() {
        
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }

    override func setEditing(editing: Bool, animated: Bool) {
        if editing{
            println("setEditing:  editing true")

            if let navigationController = self.navigationController {
                navigationController.popToRootViewControllerAnimated(true)
                
                let controller = navigationController.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                
                // Let ViewController know that it's editing an existing meme
                // at index.
                controller.index = index
                controller.editingMeme = true
                
                
                //self.dismissViewControllerAnimated(true, completion: nil)
                presentViewController(controller, animated: true, completion: nil)
            }
            
            
        } else {
            println("setEditing:  editing false")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //below code from showMemeEditor IBAction
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
*/
    

}

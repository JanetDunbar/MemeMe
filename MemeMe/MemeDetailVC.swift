//
//  MemeDetailVC.swift
//  MemeMe renamed from MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/17/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Index of meme to display
    var index = -1
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Store our AppDelegate for access to the memes.
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        self.imageView!.contentMode = .ScaleAspectFit
        self.imageView!.image = appDelegate.memes[index].memedImage
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing{

            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            // Let ViewController know that it's editing an existing meme
            // at index.
            controller.index = index
            controller.reEditingMeme = true
            
            self.dismissViewControllerAnimated(true, completion: nil)
            presentViewController(controller, animated: true, completion: nil)
            
        } else {
            println("setEditing:  editing false unexpectedly.")
        }
    }
}

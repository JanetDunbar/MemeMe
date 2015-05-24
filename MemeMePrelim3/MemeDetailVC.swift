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
    var meme = Meme()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("meme.topText = \(meme.topText)")
        
        // Do any additional setup after loading the view.
        //self.tabBarController?.tabBar.hidden = true
        self.imageView!.contentMode = .ScaleAspectFit
        self.imageView!.image = meme.memedImage
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //showMemeEditor(self.navigationItem.rightBarButtonItem!)
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing{
            println("setEditing:  editing true")
        }
        else {
            println("setEditing:  editing false")

        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //below code from showMemeEditor IBAction
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    

}

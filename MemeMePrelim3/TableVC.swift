//
//  TableVC.swift
//  MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/16/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit


class TableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        //instantiate edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    //setup sharedApplication data model
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        println(memes.count)
        return memes.count
    }
    
    //Create cell; add its data
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let currentElement = memes[indexPath.row]
        let separator  = " "
        // Configure the cell...
        cell.textLabel?.text = currentElement.topText + separator + currentElement.bottomText
        cell.imageView?.image = currentElement.memedImage
        print("currentElement.topText in tableView = \(currentElement.topText)")
        //self.tableView.reloadData()
        return cell
    }
  
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    // Inserting not enabled in this version.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            let appDelegate = object as AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            memes = appDelegate.memes
            //also delete from tableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //instantiate Meme Editor and present its view controller
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    //prepare for segue to Meme Detail
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if let identifier = segue.identifier {
            switch identifier{
                case "ShowMemeDetail":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                var seguedToMVC = segue.destinationViewController as! MemeDetailVC
                seguedToMVC.meme = memes[indexPath.row]
                }
        
            default:
            println("In Default Switch")
                
            }
        }
    }
}

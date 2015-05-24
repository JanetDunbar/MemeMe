//
//  CollectionVC.swift
//  MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/16/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

////??????????Should this be CollectionViewCell????????
//
//let reuseIdentifier = "CollectionViewCell"

class CollectionVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        self.collectionView!.reloadData()
    }

        // Register cell classes
// came with template...        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        println("memes.count = \(memes.count) inside CollectionVC")
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionCell
        let currentElement = memes[indexPath.row]
        // Configure the cell
        cell.imageView?.image = currentElement.memedImage
        //let imageView = UIImageView(image: currentElement.memedImage)
        //cell.backgroundView = imageView
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("Cell \(indexPath.row) selected")
        
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")!
        
        let detailController = object as! MemeDetailVC
        //Populate view controller with data according to the selected cell
        detailController.meme = memes[indexPath.row]
        //Present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    // MARK: UICollectionViewDelegate
    
//!!!!Remove from data array, descending order
//    sorted(indexPathForSelectedItems, { a, b in a.row > b.row })
//    
//    for indexPath in indexPathForSelectedItems {
//    call removeAtIndex(indexPath.row)
//    }
//    !!!might need to access
//    .indexPathsForSelectedItems hold the current indexes in data source array in form of indexPath.row.

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }


    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

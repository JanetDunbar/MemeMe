//
//  CollectionVC.swift
//  MemeMe renamed from MemeMePrelim3
//
//  Created by Dr. Janet M. Dunbar on 5/16/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

class CollectionVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var memes = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        self.collectionView!.reloadData()
    }
   
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the section
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionCell
        let currentElement = memes[indexPath.row]
        // Configure the cell
        cell.imageView?.image = currentElement.memedImage

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
                
        let object:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")!
        
        let detailController = object as! MemeDetailVC
        
        // Set up for editor (later).
        detailController.index = indexPath.row

        //Present the view controller using navigation.
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

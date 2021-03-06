//
//  FeedTableViewController.swift
//  Selfiegram
//
//  Created by Alyssa Gauk on 2016-05-31.
//  Copyright © 2016 Alyssa Gauk. All rights reserved.
//

import Parse

import UIKit


    

class FeedViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
   var posts = [Post]()
    
    var words = ["Hello", "my", "name", "is", "Selfigram"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query() {
            query.orderByDescending("createdAt")
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock({ (posts, error) -> Void in
                
                if let posts = posts as? [Post]{
                    self.posts = posts
                    self.tableView.reloadData()
                }
                
            })
        }
    }
            
        
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=198cff636c14aab37cb72d8a77a1b21e&tags=cat")!) { (data, response, error) -> Void in
//            
//            if let jsonUnformatted = try? NSJSONSerialization.JSONObjectWithData(data!, options: []),
//                let json = jsonUnformatted as? [String : AnyObject],
//                let photosDictionary = json["photos"] as? [String : AnyObject],
//                let photosArray = photosDictionary["photo"] as? [[String : AnyObject]]
//            {
//
//                for photo in photosArray {
//                    
//                    if let farmID = photo["farm"] as? Int,
//                        let serverID = photo["server"] as? String,
//                        let photoID = photo["id"] as? String,
//                        let secret = photo["secret"] as? String {
//                        
//                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
//                        if let photoURL = NSURL(string: photoURLString){
//                            let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//                            let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
//                            self.posts.append(post)
//                        }
//                    }
//                    
//                }
//                
//                // We use dispatch_async because we need update all UI elements on the main thread.
//                // This is a rule and you will see this again whenever you are updating UI.
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tableView.reloadData()
//                })
//                
//            }else{
//                print("error with response data")
//            }
//            
//        }
//        
//        task.resume()
    
        

        
        
       // let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
      //  let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
       // let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")
        
//        
//        posts = [post0, post1, post2, post3, post4]
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SelfieCellTableViewCell
        
        let post = self.posts[indexPath.row]
        
        cell.post = post
        
        return cell
    }


    @IBAction func cameraButtonPressed(sender: AnyObject) {
        
        print("Camera Button Pressed")
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .PhotoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        // Preset the pickerController on screen
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // setting the compression quality to 90%
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.currentUser(){
                
                //2. We create a Post object from the image
                let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                post.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        print("Post successfully saved in Parse")
                        
                        //3. Add post to our posts array, chose index 0 so that it will be added
                        //   to the top of your table instead of at the bottom (default behaviour)
                        self.posts.insert(post, atIndex: 0)
                        
                        //4. Now that we have added a post, updating our table
                        //   We are just inserting our new Post instead of reloading our whole tableView
                        //   Both method would work, however, this gives us a cool animation for free
                        
                        let indexPath =  NSIndexPath(forRow: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                    }
                })
            }
        }
        
    
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. We create a Post object from the image
//            let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//            let post = Post(image: image, user: me, comment: "My Selfie")
//            
//            //3. Add post to our posts array
//            //    Adds it to the very top of our array (and therefore our table, when we pi
//            posts.insert(post, atIndex: 0)
            
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
        
    }
    
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


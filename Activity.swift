//
//  Activity.swift
//  Selfiegram
//
//  Created by Alyssa Gauk on 2016-06-16.
//  Copyright © 2016 Alyssa Gauk. All rights reserved.
//

import Foundation

import Parse

class Activity:PFObject, PFSubclassing {
    
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    static func parseClassName() -> String {
        return "Activity"
    }
    
    convenience init(type:String, post:Post, user:PFUser){
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
    
}

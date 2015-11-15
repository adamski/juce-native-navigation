//
//  Message.swift
//  nativeNavigation
//
//  Created by Adam Elemental on 14/11/2015.
//
//

class Message {
    
    var title: String?
    var message: String?
    
    init(json: NSDictionary) {
        self.title = json["title"] as? String
        self.message = json["message"] as? String
    }
}

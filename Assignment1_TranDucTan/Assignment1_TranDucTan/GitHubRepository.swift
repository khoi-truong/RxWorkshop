//
//  GitHubRepository.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation

struct Repository {
    
    let id: Int
    let name: String
    let description: String
    let starCount: Int
    let owner: User
    
    init?(dictionary: [String: AnyObject]) {
        guard let id = dictionary["id"] as? Int else { return nil }
        guard let name = dictionary["name"] as? String else { return nil }
        guard let description = dictionary["description"] as? String else { return nil }
        guard let starCount = dictionary["stargazers_count"] as? Int else { return nil }
        guard let ownerDictionary = dictionary["owner"] as? [String: AnyObject] else { return nil }
        guard let owner = User(dictionary: ownerDictionary) else { return nil }
        self.id = id
        self.name = name
        self.description = description
        self.starCount = starCount
        self.owner = owner
    }
    
}
struct User {
    
    let id: Int
    let login: String
    let avatarURL: URL?
    
    init?(dictionary: [String: AnyObject]) {
        guard let id = dictionary["id"] as? Int else { return nil }
        guard let login = dictionary["login"] as? String else { return nil }
        self.id = id
        self.login = login
        if let avatarURLString = dictionary["avatar_url"] as? String {
            self.avatarURL = URL(string: avatarURLString)
        } else {
            self.avatarURL = nil
        }
    }
    
}

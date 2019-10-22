//
//  UserModel.swift
//  NetworkingInSwift
//
//  Created by Bold Lion on 21.10.19.
//  Copyright © 2019 Bold Lion. All rights reserved.
//

import Foundation

class UserModel {
    
    var login: String?
    var avatar_url: String?
    var name: String?
    var location: String?
    var bio: String?
}

extension UserModel {
    
    static func transformJson(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.login = dict["login"] as? String
        user.avatar_url = dict["avatar_url"] as? String
        user.name = dict["name"] as? String
        user.location = dict["location"] as? String
        user.bio = dict["bio"] as? String
        return user
    }
}

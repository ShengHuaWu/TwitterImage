//
//  AccessToken.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 20/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Serialization Error
enum SerializationError: Error {
    case missing(String)
}

// MARK: - Obtain Bearer Token
func bearerToken(with userDefaults: UserDefaults = UserDefaults.standard) -> Resource<Bool> {
    let url = URL(string: "https://api.twitter.com/oauth2/token")!
    let method = HttpMethod.post("grant_type=client_credentials")
    
    return Resource(url: url, httpMethod: method) { (json) -> Bool in
        guard let dictionary = json as? [String : Any],
            let token = dictionary["access_token"] as? String else {
            throw SerializationError.missing("access_token")
        }
        
        return userDefaults.setBearerToken(token)
    }
}

// MARK: - User Defaults Extension
extension UserDefaults {
    private static let tokenKey = "TokenKey"
    
    func setBearerToken(_ token: String) -> Bool {
        set(token, forKey: UserDefaults.tokenKey)
        return synchronize()
    }
    
    func bearerToken() -> String? {
        return string(forKey: UserDefaults.tokenKey)
    }
}

//
//  AccessToken.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 20/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - App Credentials
struct AppCredentials {
    let consumerKey: String
    let consumerSecret: String
    
    init() {
        guard let path = Bundle.main.path(forResource: "TwitterInfo", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: path) as? [String : String],
            let key = credentials["ConsumerKey"],
            let secret = credentials["ConsumerSecret"] else {
                fatalError("TwitterInfo.plist missing")
        }
        
        self.consumerKey = key
        self.consumerSecret = secret
    }
    
    func base64Encoded() -> String {
        let encodedKey = consumerKey.urlEncodedString()
        let encodedSecret = consumerSecret.urlEncodedString()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        guard let data = bearerTokenCredentials.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString(options: [])
    }
}

// MARK: - String Extension
extension String {
    func urlEncodedString(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
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
    
    @discardableResult
    func setBearerToken(_ token: String) -> Bool {
        set(token, forKey: UserDefaults.tokenKey)
        return synchronize()
    }
    
    func bearerToken() -> String? {
        return string(forKey: UserDefaults.tokenKey)
    }
}

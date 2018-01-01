//
//  ChatkitTokenDataStore.swift
//  words
//
//  Created by Neo Ighodaro on 30/12/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import PusherPlatform

class ChatkitTokenDataStore: PPTokenProvider {
    static var DATA_KEY = "WORDS_CHATKIT_TOKEN"
    
    func getToken() -> ChatkitToken {
        if let token = UserDefaults.standard.object(forKey: type(of: self).DATA_KEY) as! Data? {
            return NSKeyedUnarchiver.unarchiveObject(with: token) as! ChatkitToken
        }
        
        return ChatkitToken(access_token: nil, refresh_token: nil)
    }
    
    func setToken(_ token: ChatkitToken) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: token)
        UserDefaults.standard.set(encodedData, forKey: type(of: self).DATA_KEY)
    }
    
    func fetchToken(completionHandler: @escaping (PPTokenProviderResult) -> Void) {
        guard let access_token = getToken().access_token, access_token.count > 0 else {
            return completionHandler(PPTokenProviderResult.error(error: ChatkitTokenDataStoreError.validAccessTokenNotPresentInDatastore))
        }
        completionHandler(PPTokenProviderResult.success(token: getToken().access_token!))
    }
}

public enum ChatkitTokenDataStoreError: Error {
    case validAccessTokenNotPresentInDatastore
}

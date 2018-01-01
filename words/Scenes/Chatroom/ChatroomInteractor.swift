//
//  ChatroomInteractor.swift
//  words
//
//  Created by Neo Ighodaro on 09/12/2017.
//  Copyright (c) 2017 CreativityKills Co.. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChatroomBusinessLogic {
    func fetchChatMessages(request: Chatroom.Messages.Fetch.Request)
}

protocol ChatroomDataStore {
    var contact: Contact? { get set }
}

class ChatroomInteractor: ChatroomBusinessLogic, ChatroomDataStore {
    
    var contact: Contact?
    var presenter: ChatroomPresentationLogic?
    var worker = MessagesWorker(messagesStore: MessagesAPI())
  
    // MARK: Fetch Messages
    
    func fetchChatMessages(request: Chatroom.Messages.Fetch.Request) {
        worker.fetchMessages { (response, error) in
            if error == nil {
                self.presenter?.presentMessages(response: response!)
            }
        }
    }
    
    func addChatMessage(request: Chatroom.Messages.Create.Request) {
        
    }
}

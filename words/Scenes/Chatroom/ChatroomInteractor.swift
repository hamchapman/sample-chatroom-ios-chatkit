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

import Foundation
import PusherChatkit

protocol ChatroomBusinessLogic {
    var currentUser: PCCurrentUser? { get set }
    
    func subscribeToRoom(room: PCRoom)
    func addChatMessage(request: Chatroom.Messages.Create.Request, completionHandler: @escaping (Int?, Error?) -> Void)
    func startedTyping(inRoom room: PCRoom)
}

protocol ChatroomDataStore {
    var contact: Contact? { get set }
    var currentUser: PCCurrentUser? { get set }
}

class ChatroomInteractor: ChatroomBusinessLogic, ChatroomDataStore {
    
    var contact: Contact?
    var messages: [PCMessage] = []
    var currentUser: PCCurrentUser?
    var presenter: ChatroomPresentationLogic?
    
    // MARK: Room
    
    func subscribeToRoom(room: PCRoom) {
        currentUser?.subscribeToRoom(room: room, roomDelegate: self)
    }
    
    func addChatMessage(request: Chatroom.Messages.Create.Request, completionHandler: @escaping (Int?, Error?) -> Void) {
        currentUser?.addMessage(text: request.text, to: request.room) { messageId, error in
            DispatchQueue.main.async {
                completionHandler(messageId, error)
            }
        }
    }
    
    func startedTyping(inRoom room: PCRoom) {
        currentUser?.typing(in: room)
    }
}


// MARK: PCRoomDelegate

extension ChatroomInteractor: PCRoomDelegate {

    func newMessage(message: PCMessage) {
        DispatchQueue.main.async {
            self.messages.append(message)
            let response = Chatroom.Messages.Fetch.Response(messages: self.messages)
            self.presenter?.presentMessages(response: response)
        }
    }

    func userStartedTyping(user: PCUser) {
        DispatchQueue.main.async {
            self.presenter?.toggleUserIsTyping(for: user.displayName)
        }
    }
    
    func userStoppedTyping(user: PCUser) {
        DispatchQueue.main.async {
            self.presenter?.toggleUserIsTyping(for: user.displayName)
        }
    }
}

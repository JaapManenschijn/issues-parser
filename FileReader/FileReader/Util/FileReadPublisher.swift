//
//  FileReadPublisher.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Combine

struct FileReadPublisher: Publisher {
    typealias Output = FileReadResult
    typealias Failure = Never
    
    let fileURL: URL
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, FileReadResult == S.Input {
        let subscription = FileReadSubscription(fileURL: fileURL, subscriber: subscriber)
        
        subscriber.receive(subscription: subscription)
    }
}

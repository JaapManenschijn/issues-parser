//
//  CSVParserPublisher.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Combine
import Foundation

/// A publisher that tries to parse the provided (csv) data to a list of Users
public struct CSVParserPublisher: Publisher {
    public typealias Output = [User]
    public typealias Failure = Error
    
    let data: Data
    
    public init(data: Data) {
        self.data = data
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, [User] == S.Input {
        // Create the subscriber that does the actual parsing
        let subscription = CSVParserSubscriber(data: data, subscriber: subscriber)
        
        subscriber.receive(subscription: subscription)
    }
}

//
//  CSVParserSubscriber.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Combine
import Foundation

/// A subscriber that parses the (csv) data into a list of Users
class CSVParserSubscriber<S: Subscriber>: Subscription where S.Input == [User], S.Failure == Error {
    private let data: Data
    private var subscriber: S?
    
    init(data: Data, subscriber: S) {
        self.data = data
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        if demand > 0 {
            // Whenever there is demand, create the parser and parse the data
            let parser = CSVParser()
            let result = parser.parse(data: data)
            
            switch result {
            case .success(let users):
                _ = subscriber?.receive(users)
                subscriber?.receive(completion: .finished)
            case .failure(let error):
                subscriber?.receive(completion: .failure(error))
            }
        }
    }
    
    func cancel() {
        subscriber = nil
    }
}

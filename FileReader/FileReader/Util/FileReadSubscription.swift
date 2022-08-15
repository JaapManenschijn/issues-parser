//
//  FileReadSubscription.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Combine

class FileReadSubscription<S: Subscriber>: Subscription where S.Input == FileReadResult, S.Failure == Never {
    
    private let fileURL: URL
    private var subscriber: S?
    
    init(fileURL: URL, subscriber: S) {
        self.fileURL = fileURL
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        if demand > 0 {
            do {
                let data = try Data(contentsOf: fileURL)
                _ = subscriber?.receive(FileReadResult(url: fileURL, result: .success(data)))
                subscriber?.receive(completion: .finished)
            } catch let error {
                _ = subscriber?.receive(FileReadResult(url: fileURL, result: .failure(error)))
                subscriber?.receive(completion: .finished)
            }
        }
    }
    
    func cancel() {
        subscriber = nil
    }
}

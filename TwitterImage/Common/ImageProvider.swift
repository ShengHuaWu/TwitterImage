//
//  ImageProvider.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image Provider
final class ImageProvider {
    // MARK: Properties
    private let operationQueue = OperationQueue()
    
    // MARK: Public Methods
    static func setUp(with fileManager: FileManager = FileManager.default, userDefaults: UserDefaults = UserDefaults.standard) {
        guard userDefaults.temporaryDirectoryURL() == nil else { return }
        
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uniqueString, isDirectory: true)
        try! fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        userDefaults.setTemporaryDirectoryURL(directoryURL)
    }
    
    func load(at url: URL, to destinationURL: URL, with exist: (URL) -> Bool = { FileManager.default.fileExists(atPath: $0.path) }, completion: @escaping (Result<URL>) -> ()) {
        if exist(destinationURL) {
            completion(.success(destinationURL))
        } else {
            guard !operationQueue.isSuspended else { return }
            
            operationQueue.addOperation {
                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: destinationURL, options: .atomic)
                    
                    OperationQueue.main.addOperation {
                        completion(.success(destinationURL))
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func suspendLoading() {
        operationQueue.isSuspended = true
        operationQueue.cancelAllOperations()
    }
    
    func resumeLoading() {
        operationQueue.isSuspended = false
    }
}

// MARK: - User Defaults Extension
extension UserDefaults {
    private static let temporaryDirectoryURLKey = "TemporaryDirectoryURLKey"
    
    @discardableResult
    func setTemporaryDirectoryURL(_ url: URL) -> Bool {
        set(url, forKey: UserDefaults.temporaryDirectoryURLKey)
        return synchronize()
    }
    
    func temporaryDirectoryURL() -> URL? {
        return url(forKey: UserDefaults.temporaryDirectoryURLKey)
    }
}

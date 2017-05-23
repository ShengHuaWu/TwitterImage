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
    private let fileManager: FileManager
    private let userDefaults: UserDefaults
    private let operationQueue = OperationQueue()
    
    // MARK: Designated Initializer
    init(fileManager: FileManager = FileManager.default, userDefaults: UserDefaults = UserDefaults.standard) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
        
        if self.userDefaults.temporaryDirectoryURL() == nil {
            let uniqueString = ProcessInfo.processInfo.globallyUniqueString
            let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(uniqueString, isDirectory: true)
            try! self.fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            self.userDefaults.setTemporaryDirectoryURL(directoryURL)
        }
    }
    
    // MARK: Public Methods
    func load(_ url: URL, for identifier: String, with completion: @escaping (Result<URL>) -> ()) {
        guard let directoryURL = userDefaults.temporaryDirectoryURL() else { return }
        
        let fileURL = directoryURL.appendingPathComponent(identifier)
        if fileManager.fileExists(atPath: fileURL.path) {
            completion(.success(fileURL))
        } else {
            operationQueue.addOperation {
                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: fileURL, options: .atomic)
                    
                    OperationQueue.main.addOperation {
                        completion(.success(fileURL))
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

protocol ImageProviderProtocol {
    func load(_ url: URL, for identifier: String, with completion: @escaping (Result<URL>) -> ())
}

extension ImageProvider: ImageProviderProtocol {}

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

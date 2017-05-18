//
//  WebService.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 17/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Result
enum Result<T> {
    case success(T)
    case failure(Error)
}

// MARK: - HTTP Method
enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
    
    func map<U>(f: (Body) -> U) -> HttpMethod<U> {
        switch self {
        case .get: return .get
        case let .post(body): return .post(f(body))
        }
    }
}

// MARK: - Resource
struct Resource<T> {
    let url: URL
    let httpMethod: HttpMethod<Data>
    let parser: (Data) throws -> T
}

typealias JSONDictionary = [String : Any]

extension Resource {
    init(url: URL, httpMethod: HttpMethod<JSONDictionary> = .get, parseJSON: @escaping (Any) throws -> T) {
        self.url = url
        self.httpMethod = httpMethod.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parser = { data in
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return try parseJSON(json)
        }
    }
}

// MARK: - URL Request Extension
extension URLRequest {
    init<T>(resource: Resource<T>) {
        self.init(url: resource.url)
        
        httpMethod = resource.httpMethod.method
        if case let .post(body) = resource.httpMethod {
            httpBody = body
        }
    }
}

// MARK: - Web Service
final class WebService: WebServiceProtocol {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ()) {
        let request = URLRequest(resource: resource)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                if let data = data {
                    do {
                        let result = try resource.parser(data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
}

protocol WebServiceProtocol {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ())
}

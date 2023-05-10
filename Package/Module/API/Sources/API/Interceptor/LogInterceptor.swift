//
//  LogInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/31.
//

import Foundation
import Logger
import Network

public struct LogInterceptor: Interceptor {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Lifeycle
    public func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        Logger.info("""
            
            📮 Request
               URL         : \(request.url?.absoluteString ?? "[\(target.url as Any)]")
               METHOD      : \(request.httpMethod ?? "[\(target.method.rawValue)]")
               HEADERS     : \(printPretty(request.allHTTPHeaderFields ?? [:], start: 3, indent: 2))
               BODY        :
                 \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "unknown")
            
            """,
            userInfo: [
                .category: "NETWORK"
            ]
        )
        
        completion(.success(request))
    }
    
    public func response(
        _ response: Response,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<Response, any Error>) -> Void
    ) {
        switch response {
        case let .success((data, response)):
            let response = response as? HTTPURLResponse
            
            Logger.info("""
                
                📭 Response
                   URL         : \(response?.url?.absoluteString ?? "[\(target.url?.absoluteString as Any)]")
                   STATUS CODE : \((response?.statusCode) ?? -1)
                   HEADERS     : \(printPretty(response?.allHeaderFields ?? [:], start: 3, indent: 2))
                   DATA        :
                     \(String(data: data, encoding: .utf8) ?? "unknown")
                
                """,
                userInfo: [
                    .category: "NETWORK"
                ]
            )
            
        case let .failure(error):
            Logger.info("""
                
                🚨 Response
                   URL         : \(target.url?.absoluteString as Any)
                   Error       : \(String(describing: error))
                
                """,
                userInfo: [
                    .category: "NETWORK"
                ]
            )
        }
        
        completion(.success(response))
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func printPretty(_ dictionary: [AnyHashable: Any], start: Int, indent: Int) -> String {
        let string = dictionary.map { key, value -> String in
            var value = value
            if let dictionary = value as? [AnyHashable: Any] {
                value = printPretty(dictionary, start: start + indent, indent: indent)
            }
            
            let indent = String(repeating: " ", count: indent)
            return "\(indent)\(key): \(value)"
        }
            .map { "\(String(repeating: " ", count: start))\($0)" }
            .joined(separator: "\n")
        
        return "\n\(string)"
    }
}

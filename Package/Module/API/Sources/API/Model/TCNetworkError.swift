//
//  TCNetworkError.swift
//  
//
//  Created by JSilver on 2023/02/13.
//

import Foundation

public enum TCNetworkError: Error {
    case emptyResponse
    case invalidStatusCode(Int)
}

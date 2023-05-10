//
//  CodeServiceError.swift
//  
//
//  Created by JSilver on 2023/03/28.
//

import Service

public enum CodeServiceError: Error {
    case unknown
    case keyNotEnough
    case keyNotFound
    case blockedKey
}

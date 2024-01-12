//
//  Failure.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

enum Failure: Error {
    case apiError(String)
    case decodingError
    case badUrl
    case domainError
}

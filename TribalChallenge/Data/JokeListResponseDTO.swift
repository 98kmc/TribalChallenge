//
//  JokeListResponeDTO.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

struct JokeListResponseDTO: Codable {
    
    let total: Int?
    let result: [JokeDTO]?
}

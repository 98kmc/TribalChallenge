//
//  Repository.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

protocol JokeRepositoryRepresentable {
    
    func fetchJoke() async throws -> JokeDTO?
}
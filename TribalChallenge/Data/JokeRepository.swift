//
//  JokeRepository.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

final class JokeRepository: JokeRepositoryRepresentable {
    
    private let baseURL = "https://api.chucknorris.io"
    
    func fetchJoke() async throws -> JokeDTO? {
        let endpont = "/jokes/random"
        guard let url = URL(string: baseURL + endpont) else { throw Failure.badUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let factsData = try JSONDecoder().decode(JokeDTO.self, from: data)
        
        return factsData
    }
}

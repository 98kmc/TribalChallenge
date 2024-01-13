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
        let jokeData = try JSONDecoder().decode(JokeDTO.self, from: data)
        
        return jokeData
    }
    
    func fetchJokeWithCategory(_ category: String) async throws -> JokeDTO? {
        let endpont = "/jokes/random"
        
        guard var urlComponents = URLComponents(string: baseURL + endpont)  else { throw Failure.badUrl }
        urlComponents.queryItems = [URLQueryItem(name: "category", value: category)]
        guard let url = urlComponents.url else { throw Failure.badUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let jokeData = try JSONDecoder().decode(JokeDTO.self, from: data)
        
        return jokeData
    }
    
    func fetchSearchedJokes(_ text: String) async throws -> [JokeDTO]? {
        let endpont = "/jokes/search"
        
        guard var urlComponents = URLComponents(string: baseURL + endpont)  else { throw Failure.badUrl }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: text)]
        guard let url = urlComponents.url else { throw Failure.badUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let jokeData = try JSONDecoder().decode(JokeListResponseDTO.self, from: data)
        
       guard let list = jokeData.result else { return nil }
        
        return list
    }
}

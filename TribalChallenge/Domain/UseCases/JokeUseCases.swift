//
//  JokeUseCases.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

final class JokeUseCases {
    let repository: JokeRepositoryRepresentable
    
    init(repository: JokeRepositoryRepresentable) {
        self.repository = repository
    }
    
    func getSingleJoke() async -> Result<Joke, Failure> {
        
        do {
            
            let result = try await repository.fetchJoke()
            guard let jokesData = result else { return .failure(.apiError("Fetched Data is Null")) }
            
            return .success(jokesData.toJokeObject())
        } catch let error as Failure {
            
            return .failure(error)
        } catch {
            print(error)
            return .failure(.apiError("Repostory Failure"))
        }
    }
}

extension JokeDTO {
    
    func toJokeObject() -> Joke {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        return Joke(categories: self.categories?.map { JokeCategory(rawValue: $0) ?? .unknown } ?? [],
             created_at: self.created_at ?? formatter.string(from: Date()),
             icon_url: self.icon_url ?? "",
             id: self.id ?? UUID().uuidString,
             url: self.url ?? "",
             value: self.value ?? "")
    }
}

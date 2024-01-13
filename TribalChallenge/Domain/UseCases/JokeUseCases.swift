//
//  JokeUseCases.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

final class JokeUseCases {
    
    private let repository: JokeRepositoryRepresentable
    
    init(repository: JokeRepositoryRepresentable) {
        self.repository = repository
    }
    
    func getSingleJoke(with category: JokeCategory) async -> Result<Joke, Failure> {
        
        do {
            
            let result = category != .unknown
            ? try await repository.fetchJokeWithCategory(category.rawValue)
            : try await repository.fetchJoke()
            
            guard let jokesData = result else { return .failure(.apiError("Fetched Data is Null")) }
            
            return .success(jokesData.toJokeObject())
        } catch let error as Failure {
            
            return .failure(error)
        } catch {
            print(error)
            return .failure(.apiError("Repostory Failure"))
        }
    }
    
    func searchJokes(text: String) async -> Result<[Joke], Failure> {
        
        do {
            
            let result = try await repository.fetchSearchedJokes(text)
            
            guard let jokesData = result else { return .failure(.apiError("Fetched Data is Null")) }
            
            return .success(jokesData.map { $0.toJokeObject() })
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let date = formatter.date(from: self.created_at ?? "") ?? Date()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: date)
        
        return Joke(categories: self.categories?.map { JokeCategory(rawValue: $0) ?? .unknown } ?? [],
             created_at: formattedDate,
             icon_url: self.icon_url ?? "",
             id: self.id ?? UUID().uuidString,
             url: self.url ?? "",
             value: self.value ?? "")
    }
}

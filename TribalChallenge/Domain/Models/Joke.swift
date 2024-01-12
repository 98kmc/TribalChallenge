//
//  Joke.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

enum JokeCategory: String {
    case animal
    case career
    case celebrity
    case dev
    case explicit
    case fashion
    case food
    case history
    case money
    case movie
    case music
    case political
    case religion
    case science
    case sport
    case travel
    case unknown
}

struct Joke: Identifiable {
    let categories: [JokeCategory]
    let created_at: String
    let icon_url: String
    let id: String
    let url: String
    let value: String
}

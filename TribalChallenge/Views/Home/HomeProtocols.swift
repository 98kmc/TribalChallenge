//
//  HomeProtocols.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

protocol HomeViewModelRepresentable {
    
    var viewStateDidChange: ((HomeViewState) -> Void)? { get set }
    var currentJoke: Joke! { get }
    
    func didTapNext()
    
    func didTapSearch()
    
    func didSelectCategory(category: JokeCategory)
}

protocol SearchViewModelRepresentable {
    
    var viewStateDidChange: ((HomeViewState) -> Void)? { get set }
    var searchResultDidChange: (([Joke]) -> Void)? { get set }
    
    func search(text: String)
    
    func clearResults()
}

protocol HomeViewModelDelegate {
    
    func presentSearchSheet()
}

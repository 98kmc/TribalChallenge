//
//  HomeProtocols.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

protocol HomeViewModelRepresentable {
    
    var viewStateDidChange: ((HomeViewState) -> Void)? { get set }
    var currentJoke: Joke! { get set }
    
    func didTapNext()
    
    func didTapSearch()
    
    func didSelectCategory(category: JokeCategory)
}

protocol SearchViewModelRepresentable {
    
}

protocol HomeViewModelDelegate {
    
    func presentSearchSheet()
}

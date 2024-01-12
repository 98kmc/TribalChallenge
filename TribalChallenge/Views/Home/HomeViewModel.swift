//
//  HomeViewModel.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

enum HomeViewState {
    case loading
    case loaded
}
final class HomeViewModel {
    
    let useCases: JokeUseCases
    
    var viewStateDidChange: ((HomeViewState) -> Void)?
    
    var currentJoke: Joke!
    
    var state = HomeViewState.loading {
        didSet {
          viewStateDidChange?(state)
        }
    }
    
    init(useCases: JokeUseCases) {
        self.useCases = useCases
    }
    
    func didAppear() {
        Task {
            await loadNewJoke()
        }
    }
    
    func didTapNext() {
        Task {
            await loadNewJoke()
        }
    }
    
    private func loadNewJoke() async {
        state = .loading
        let data = await useCases.getSingleJoke()
        
        switch data {
        case .success(let joke):
            currentJoke = joke
            state = .loaded
        case .failure(let error):
            print(error)
        }
    }
}

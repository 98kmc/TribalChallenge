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
    let coordinator: HomeViewModelDelegate
    
    var viewStateDidChange: ((HomeViewState) -> Void)?
    var currentJoke: Joke!
    var selectedCategory: JokeCategory = .unknown

    var state = HomeViewState.loading {
        didSet {
          viewStateDidChange?(state)
        }
    }
    
    init(useCases: JokeUseCases, coordinator: HomeViewModelDelegate) {
        self.useCases = useCases
        self.coordinator = coordinator
    }
    
    private func loadNewJoke() async {
        state = .loading
        let data = await useCases.getSingleJoke(with: selectedCategory)
        
        switch data {
        case .success(let joke):
            currentJoke = joke
            print(joke)
            state = .loaded
        case .failure(let error):
            print(error)
        }
    }
}

extension HomeViewModel: HomeViewModelRepresentable {
    
    func didTapNext() {
        let lastJoke = currentJoke
        
        Task {
            while lastJoke == currentJoke {
                await loadNewJoke()
            }
        }
    }
    
    func didTapSearch() {
        coordinator.presentSearchSheet()
    }
    
    func didSelectCategory(category: JokeCategory) {
        selectedCategory = category
    }
}

extension HomeViewModel: SearchViewModelRepresentable {
    
}

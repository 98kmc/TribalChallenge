//
//  HomeCoordinator.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

final class HomeCoordinator<R: AppRouter> : Coordinator {
    
    private let router: R
    private let repository: JokeRepository
    private let usecases: JokeUseCases
    
    init(router: R) {
        self.router = router
        repository = JokeRepository()
        usecases = JokeUseCases(repository: repository)
    }
    
    func start() {
        
            let homeViewModel = HomeViewModel(useCases: usecases)
            let vc = HomeViewController(viewModel: homeViewModel)
            router.navigationController.pushViewController(vc, animated: false)
    }
}

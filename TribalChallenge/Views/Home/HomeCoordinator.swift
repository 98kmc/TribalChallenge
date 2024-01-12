//
//  HomeCoordinator.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

final class HomeCoordinator<R: AppRouter> : Coordinator {
    
    private let router: R
    
    init(router: R) {
        self.router = router
    }
    
    func start() {
        router.navigationController.pushViewController(HomeViewController(), animated: false)
    }
}


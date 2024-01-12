//
//  App.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

final class App {
    var navigationController = UINavigationController()
    
    private let firstRoute: AppTransition = .showHome
}

extension App: Coordinator {
    
    func start() {
        
        process(route: firstRoute)
    }
}

extension App: AppRouter {
    
    func exit() {
        // In this Router context - the only exit left is the main screen.
        // Logout - clean tokens - local cache - offline database if needed etc.
        navigationController.popToRootViewController(animated: true)
    }
    
    func process(route: AppTransition) {
        print("Processing route: \(route)")
        let coordinator = route.coordinatorFor(router: self)
        coordinator.start()
    }
}


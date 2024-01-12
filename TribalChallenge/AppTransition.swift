//
//  AppTransition.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import Foundation

enum AppTransition {
    
    case showHome
    
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        
        switch self {
        case .showHome: return HomeCoordinator(router: router)
        }
    }
}

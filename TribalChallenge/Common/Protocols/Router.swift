//
//  Router.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

protocol Router {
    associatedtype Route
    
    func process(route: Route)
}

protocol AppRouter: Router where Route == AppTransition {
    
    var navigationController: UINavigationController { get set }
}


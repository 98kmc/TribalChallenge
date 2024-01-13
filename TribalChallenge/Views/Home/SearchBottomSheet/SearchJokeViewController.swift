//
//  SearchJokeViewController.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

class SearchJokeViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet private weak var emptyDataView: UIView!
    
    let viewModel: SearchViewModelRepresentable
    
    // MARK: Initializers
    init(viewModel: SearchViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: "SearchJokeViewController",
                   bundle: Bundle(for: SearchJokeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}

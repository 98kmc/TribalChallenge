//
//  HomeViewController.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var jokeImageView: UIImageView!
    @IBOutlet private weak var jokeTextLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var categoriesPopUpButton: UIButton!
    @IBOutlet private weak var categorySelectionLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    
    var viewModel: HomeViewModelRepresentable
    
    
    // MARK: Initializers
    init(viewModel: HomeViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController",
                   bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewStateDidChange = { [unowned self] state in
            
            Task {
                switch state {
                case .loading:
                    await MainActor.run {
                        setUpViews(hidden: true)
                        self.view.backgroundColor = .white.withAlphaComponent(0.85)
                        self.loadingIndicator.isHidden = false
                        self.loadingIndicator.startAnimating()
                    }
                case .loaded:
                    let image = await fetchImage(from:viewModel.currentJoke.icon_url)
                    await MainActor.run {
                        self.view.backgroundColor = .white
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                        setUpViews(image: image ?? UIImage(named: "placeholder"), text: viewModel.currentJoke.value)
                    }
                    
                }
            }
        }
        
        setUpCategoriesButton()
        viewModel.didTapNext()
    }
    
    
    // MARK: Actions
    @IBAction func onNextButtonClick(_ sender: UIView) {
        viewModel.didTapNext()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        viewModel.didTapSearch()
    }
    
    // MARK: Private Methods
    private func setUpViews(hidden: Bool = false, image: UIImage? = nil, text: String = "") {
        self.categorySelectionLabel.isHidden = hidden
        self.categoriesPopUpButton.isHidden = hidden
        self.jokeImageView.image = image
        self.jokeTextLabel.text = text
        self.nextButton.isHidden = hidden
        self.searchButton.isHidden = hidden
    }
    
    private func setUpCategoriesButton() {
        
        let onMenuItemClick = { (item: UIAction) in
            self.viewModel.didSelectCategory(category: JokeCategory(rawValue: item.title) ?? .unknown)
        }

        var categoriesMenu: [UIMenuElement] = []
        for category in JokeCategory.allCases.map({ $0.rawValue }) {
            categoriesMenu.append(UIAction(title: category, handler: onMenuItemClick))
        }
        
        categoriesPopUpButton.menu = UIMenu(options: .displayInline, children: categoriesMenu)
        
        categoriesPopUpButton.showsMenuAsPrimaryAction = true
        categoriesPopUpButton.changesSelectionAsPrimaryAction = true
    }
}

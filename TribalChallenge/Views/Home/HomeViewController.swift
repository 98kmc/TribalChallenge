//
//  HomeViewController.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private var jokeImageView: UIImageView!
    @IBOutlet private var jokeTextLabel: UILabel!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var nextButton: UIButton!
    
    var viewModel: HomeViewModel
    
    
    // MARK: Initializers
    init(viewModel: HomeViewModel) {
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
                        resetViews()
                        self.view.backgroundColor = .white.withAlphaComponent(0.85)
                        self.loadingIndicator.startAnimating()
                    }
                case .loaded:
                    let image = await fetchImage(from:viewModel.currentJoke.icon_url)
                    await MainActor.run {
                        self.view.backgroundColor = .white
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                        self.nextButton.isHidden = false
                        self.jokeImageView.image = image ?? UIImage(named: "placeholder")
                        self.jokeTextLabel.text = viewModel.currentJoke.value
                    }
                    
                }
            }
        }
        
        viewModel.didAppear()
    }
    
    @IBAction func onNextButtonClick(_ sender: UIView) {
        viewModel.didTapNext()
    }
    
    // MARK: Private Methods
    private func resetViews() {
        self.jokeImageView.image = nil
        self.jokeTextLabel.text = ""
        self.nextButton.isHidden = true
        self.loadingIndicator.isHidden = false
    }
}

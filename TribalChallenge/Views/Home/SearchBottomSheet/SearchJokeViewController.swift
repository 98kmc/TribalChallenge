//
//  SearchJokeViewController.swift
//  TribalChallenge
//
//  Created by Miguel on 12/01/2024.
//

import UIKit

class SearchJokeViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionViewContainer: UIView!
    @IBOutlet private weak var emptyDataView: UIView!
    
    var viewModel: SearchViewModelRepresentable
    private var collectionViewController: SearchResultCollectionViewController!
    
    // MARK: Initializers
    init(viewModel: SearchViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: "SearchJokeViewController",
                   bundle: Bundle(for: SearchJokeViewController.self))
        self.collectionViewController = SearchResultCollectionViewController(viewModel: viewModel, onEmptyData: showEmptyData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        collectionViewContainer.backgroundColor = .red
        
        addChild(collectionViewController)
        collectionViewContainer.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionViewController.view.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
                collectionViewController.view.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor),
                collectionViewController.view.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor),
                collectionViewController.view.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor)
            ])
        
        setUpViews()
        viewModel.viewStateDidChange = { [unowned self] state in
            
            switch state {
            case .loading:
                
                DispatchQueue.main.sync {
                    viewModel.clearResults()
                    self.emptyDataView.isHidden = true
                    self.collectionViewContainer.isHidden = true
                    self.loadingIndicator.isHidden = false
                    self.loadingIndicator.startAnimating()
                }
            case .loaded:
                DispatchQueue.main.sync {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.emptyDataView.isHidden = true
                    self.collectionViewContainer.isHidden = false
                }
            }
        }
    }
    
    // MARK: Private Methods
    private func setUpViews() {
        
        searchBar.text = ""
        loadingIndicator.isHidden = true
        collectionViewContainer.isHidden = true
        emptyDataView.isHidden = true
    }
    
    private func showEmptyData() {
        Task {

            await MainActor.run {
                loadingIndicator.isHidden = true
                collectionViewContainer.isHidden = true
                emptyDataView.isHidden = false
            }
        }
    }
}

extension SearchJokeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText.count >= 3 else { return }
        
        viewModel.search(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
           
            guard searchText.count >= 3 else { return }
            
            viewModel.search(text: searchText)
        }
    }
}

final class SearchResultCollectionViewController: UICollectionViewController {
    
    // MARK: - Typealias
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, Joke>
    private typealias DataSource = UICollectionViewDiffableDataSource<String, Joke>
    
    var viewModel: SearchViewModelRepresentable
    private var elements: [Joke] = []
    private lazy var dataSource: DataSource = { createDatasource() }()
    private let refreshControl = UIRefreshControl()
    private let section = "OneSection"
    private let onEmptyData: () -> Void
    
    // MARK: Initializers
    init(viewModel: SearchViewModelRepresentable, onEmptyData: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onEmptyData = onEmptyData
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: String(describing: JokeItemCell.self), bundle: nil), forCellWithReuseIdentifier: "JokeItemCell")
        collectionView.collectionViewLayout = createLayout()
        applySnapshot(animatingDifferences: true)
        
        viewModel.searchResultDidChange = { [unowned self] resultList in
            
            guard !resultList.isEmpty else {
                onEmptyData()
                return
            }
            
            Task {
                await MainActor.run {
                    elements = resultList
                    applySnapshot(animatingDifferences: true)
                }
            }
        }
    }
    
    // MARK: Private Methods
    private func applySnapshot(animatingDifferences: Bool = false) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        
        snapshot.appendItems(elements, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func createDatasource() -> DataSource {
        
        UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, _ in
            
            let jokeItem = elements[indexPath.row]
            let cell: JokeItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JokeItemCell", for: indexPath) as! JokeItemCell
            cell.configure(with: jokeItem)
            
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1)
        
        let group: NSCollectionLayoutGroup
        let  groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(0.25))
        
        group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: 1))
        
        group.interItemSpacing = .fixed(CGFloat(10))
        group.contentInsets =  NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 1, bottom: 8, trailing: 1)
        section.interGroupSpacing = CGFloat(10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

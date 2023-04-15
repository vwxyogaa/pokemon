//
//  HomeViewController.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
    }
    
    // MARK: - Helpers
    private func configureViews() {
        title = "Pokedex"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        configureCollectionView()
    }
    
    private func initObservers() {
        viewModel.pokemons.drive(onNext: { [weak self] pokemon in
            if pokemon.isEmpty {
                self?.pokemonListCollectionView.setBackground(imageName: "xmark_icloud", messageImage: "Not Found")
            } else {
                self?.pokemonListCollectionView.clearBackground()
            }
            self?.pokemonListCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        self.pokemonListCollectionView.register(UINib(nibName: "PokemonListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonListCollectionViewCell")
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.pokemonListCollectionView.refreshControl = refreshControl
        self.pokemonListCollectionView.dataSource = self
        self.pokemonListCollectionView.delegate = self
    }
    
    // MARK: - Action
    @objc
    private func refreshData() {
        self.viewModel.refresh()
        self.pokemonListCollectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemonsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCollectionViewCell", for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        let pokemon = viewModel.pokemon(at: indexPath.row)
        cell.configureContentDashboard(pokemon: pokemon)
        viewModel.loadNextPage(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let detailPokemonViewModel = DetailViewModel(detailUseCase: Injection().provideDetailUeCase(), pokemon: viewModel.pokemon(at: indexPath.row))
        detailViewController.viewModel = detailPokemonViewModel
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpaceHorizontal: CGFloat = 15 * (2 + 1)
        let paddingSpaceVertical: CGFloat = 8 * (5 + 2)
        let availableWidth = self.view.frame.width - paddingSpaceHorizontal
        let availableHeight = self.view.frame.height - paddingSpaceVertical
        let widthPerItem = (availableWidth / 2)
        let heightPerItem = (availableHeight / 5)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

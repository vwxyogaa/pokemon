//
//  DetailViewController.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypesLabel: UILabel!
    @IBOutlet weak var pokemonMovesLabel: UILabel!
    @IBOutlet weak var catchButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: DetailViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
    }
    
    // MARK: - Helpers
    private func configureViews() {
        navigationController?.navigationBar.tintColor = UIColor(named: "BlueColor")
        configureCatchButton()
    }
    
    private func initObservers() {
        viewModel.pokemon.drive(onNext: {[weak self] pokemon in
            self?.configureData(pokemon: pokemon)
            self?.updateCatchButton(isCatched: pokemon?.nickname != nil)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [weak self] errorMessage in
            self?.showErrorSnackBar(message: errorMessage)
        }).disposed(by: disposeBag)
    }
    
    private func configureCatchButton() {
        catchButton.backgroundColor = UIColor(named: "BlueColor")
        catchButton.layer.cornerRadius = 10
        catchButton.addTarget(self, action: #selector(catchButtonClicked(_:)), for: .touchUpInside)
    }
    
    private func configureData(pokemon: Pokemon?) {
        if let imageUrl = pokemon?.sprites?.other?.officialArtwork?.frontDefault {
            self.pokemonImageView.loadImage(uri: imageUrl, placeholder: getUIImage(named: "pokeball"))
        } else {
            self.pokemonImageView.image = getUIImage(named: "pokeball")
        }
        self.pokemonNameLabel.text = (pokemon?.nickname != nil) ? "\(pokemon?.name?.capitalized ?? "") (\(pokemon?.nickname ?? ""))" : pokemon?.name?.capitalized
        self.pokemonTypesLabel.text = pokemon?.types?.compactMap({ $0.type?.name }).joined(separator: ", ")
        self.pokemonMovesLabel.text = pokemon?.moves?.compactMap({ $0.move?.name }).joined(separator: ", ")
    }
    
    private func updateCatchButton(isCatched: Bool) {
        if isCatched {
            catchButton.tag = 1
            catchButton.setTitle("Release", for: .normal)
            catchButton.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            catchButton.backgroundColor = UIColor(named: "GrayColor")
        } else {
            catchButton.tag = 0
            catchButton.setTitle("Catch", for: .normal)
            catchButton.setTitleColor(UIColor(named: "GrayColor"), for: .normal)
            catchButton.backgroundColor = UIColor(named: "BlueColor")
        }
        catchButton.layer.borderWidth = 1.5
        catchButton.layer.borderColor = UIColor(named: "BlueColor")?.cgColor
    }
    
    private func dialogSuccessCatch() {
        let dialogMessage = UIAlertController(title: "", message: "Success to catch it!.\nPlease give a nickname", preferredStyle: .alert)
        dialogMessage.addTextField { textfield in
            textfield.placeholder = "Type nickname"
        }
        let done = UIAlertAction(title: "Done", style: .default) { _ in
            let nickname = dialogMessage.textFields?.first?.text ?? "-"
            self.viewModel.catchPokemon(nickname: nickname)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(done)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func dialogFailedCatch() {
        let dialogMessage = UIAlertController(title: "", message: "Failed to catch it.\nPlease try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func dialogRelease() {
        let dialogMessage = UIAlertController(title: "", message: "Are you sure you want to release this pokemon?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.releasedPokemon()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(yes)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Action
    @objc
    private func catchButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            let catchPokemon = Bool.random()
            catchPokemon ? self.dialogSuccessCatch() : self.dialogFailedCatch()
        } else {
            self.dialogRelease()
        }
    }
}

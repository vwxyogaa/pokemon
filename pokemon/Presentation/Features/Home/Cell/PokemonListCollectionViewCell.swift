//
//  PokemonListCollectionViewCell.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit

class PokemonListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    func configureContentDashboard(pokemon: Pokemon?) {
        self.pokemonNameLabel.text = pokemon?.name?.capitalized
        if let imageUrl = pokemon?.sprites?.other?.officialArtwork?.frontDefault {
            self.pokemonImageView.loadImage(uri: imageUrl, placeholder: getUIImage(named: "pokeball"))
        } else {
            self.pokemonImageView.image = getUIImage(named: "pokeball")
        }
    }
    
    func configureContentMyBag(myBag: PokemonBag?) {
        self.pokemonNameLabel.text = myBag?.nickname
        if let imageUrl = myBag?.pokemon.sprites?.other?.officialArtwork?.frontDefault {
            self.pokemonImageView.loadImage(uri: imageUrl, placeholder: getUIImage(named: "pokeball"))
        } else {
            self.pokemonImageView.image = getUIImage(named: "pokeball")
        }
    }
}

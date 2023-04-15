//
//  PokemonList.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import Foundation

struct PokemonList: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonResults]?
}

//
//  PokemonResults.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import Foundation

struct PokemonResults: Codable {
    let name: String?
    let url: String?
}

extension PokemonResults {
    var id: Int {
        get {
            guard let url = self.url else { return 0 }
            let id = url.split(separator: "/").filter { !$0.isEmpty }
            return Int(id.last ?? "0") ?? 0
        }
    }
}

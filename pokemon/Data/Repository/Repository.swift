//
//  Repository.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - Remote
    func getPokemonList(page: Int) -> Observable<[Int]>
    func getPokemonDetail(id: Int) -> Observable<Pokemon>
}

final class Repository: NSObject {
    typealias PokemonInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: PokemonInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - Remote
    func getPokemonList(page: Int) -> Observable<[Int]> {
        return remote.getPokemonList(page: page)
            .compactMap { $0.results?.compactMap({ $0.id }) }
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        return remote.getPokemonDetail(id: id)
    }
}

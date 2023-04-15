//
//  HomeUseCase.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import RxSwift

protocol HomeUseCaseProtocol {
    func getPokemonList(page: Int) -> Observable<[Int]>
    func getPokemonDetail(id: Int) -> Observable<Pokemon>
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getPokemonList(page: Int) -> Observable<[Int]> {
        return self.repository.getPokemonList(page: page)
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        return self.repository.getPokemonDetail(id: id)
    }
}

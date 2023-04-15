//
//  MyBagUseCase.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import RxSwift

protocol MyBagUseCaseProtocol {
    func getMyBags() -> Observable<[PokemonBag]>
}

final class MyBagUseCase: MyBagUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getMyBags() -> Observable<[PokemonBag]> {
        return repository.getMyBags()
    }
}

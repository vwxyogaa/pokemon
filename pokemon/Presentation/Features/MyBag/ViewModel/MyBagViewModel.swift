//
//  MyBagViewModel.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import RxSwift
import RxCocoa

class MyBagViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let myBagUseCase: MyBagUseCaseProtocol
    
    private let _pokemon = BehaviorRelay<[PokemonBag]>(value: [])
    
    init(myBagUseCase: MyBagUseCaseProtocol) {
        self.myBagUseCase = myBagUseCase
        super.init()
    }
    
    var pokemons: Driver<[PokemonBag]> {
        return _pokemon.asDriver()
    }
    
    var pokemonsCount: Int {
        return _pokemon.value.count
    }
    
    func pokemon(at index: Int) -> PokemonBag? {
        return _pokemon.value[safe: index]
    }
    
    func refresh() {
        getMyCollections()
    }
    
    func getMyCollections() {
        self._isLoading.accept(true)
        myBagUseCase.getMyBags()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._pokemon.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

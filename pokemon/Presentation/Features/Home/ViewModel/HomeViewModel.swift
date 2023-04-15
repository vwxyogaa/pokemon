//
//  HomeViewModel.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let homeUseCase: HomeUseCaseProtocol
    
    private var pokemonResults = [Pokemon]()
    private var pokemonResultsCount = 0
    private var page = 1
    private var canLoadNextPage = false
    
    private let _pokemons = BehaviorRelay<[Pokemon]>(value: [])
    
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
        super.init()
        getPokemonList()
    }
    
    var pokemons: Driver<[Pokemon]> {
        return _pokemons.asDriver()
    }
    
    var pokemonsCount: Int {
        return _pokemons.value.count
    }
    
    func pokemon(at index: Int) -> Pokemon? {
        return _pokemons.value[safe: index]
    }
    
    func refresh() {
        pokemonResults = []
        pokemonResultsCount = 0
        page = 1
        getPokemonList()
    }
    
    func getPokemonList() {
        self._isLoading.accept(true)
        homeUseCase.getPokemonList(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.pokemonResultsCount += result.count
                result.forEach { id in
                    self.getPokemonDetail(id: id)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func getPokemonDetail(id: Int) {
        self._isLoading.accept(true)
        homeUseCase.getPokemonDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.pokemonResults.append(result)
                if self.pokemonResults.count == self.pokemonResultsCount {
                    self.page += 1
                    self.canLoadNextPage = false
                    self._pokemons.accept(self.pokemonResults.sorted { $0.id ?? 0 < $1.id ?? 0})
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadNextPage(index: Int) {
        if !canLoadNextPage {
            if _pokemons.value.count - 2 == index {
                canLoadNextPage = true
                getPokemonList()
            }
        }
    }
}

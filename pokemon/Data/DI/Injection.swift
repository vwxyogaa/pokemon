//
//  Injection.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

final class Injection {
    func provideHomeUseCase() -> HomeUseCaseProtocol {
        let repository = provideRepository()
        return HomeUseCase(repository: repository)
    }
    
    func provideDetailUeCase() -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailUseCase(repository: repository)
    }
    
    func provideMyBagUseCase() -> MyBagUseCaseProtocol {
        let repository = provideRepository()
        return MyBagUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        let localDataSource = LocalDataSource()
        return Repository.sharedInstance(remoteDataSource, localDataSource)
    }
}

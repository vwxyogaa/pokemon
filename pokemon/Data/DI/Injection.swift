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
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource)
    }
}

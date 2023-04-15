//
//  LocaleDataSource.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import RxSwift
import UIKit
import CoreData

protocol LocalDataSourceProtocol {
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)>
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool>
    func releasedPokemon(nickname: String) -> Observable<Bool>
    func getMyBags() -> Observable<[PokemonBag]>
}

final class LocalDataSource: LocalDataSourceProtocol {
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)> {
        return Observable<(Bool, String?)>.create { observer in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Disposables.create() }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyBag")
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    guard let nickname = data.value(forKey: "nickname") as? String, let pokemonData = data.value(forKey: "pokemon") as? Data, let pokemon = Utils.getPokemonFromData(data: pokemonData) else { return Disposables.create() }
                    if pokemon.id == pokemonId {
                        observer.onNext((true, nickname))
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
                observer.onNext((false, nil))
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
    
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Disposables.create() }
            let managedContext = appDelegate.persistentContainer.viewContext
            guard let myCollectionEntity = NSEntityDescription.entity(forEntityName: "MyBag", in: managedContext) else { return Disposables.create() }
            let myCollection = NSManagedObject(entity: myCollectionEntity, insertInto: managedContext)
            myCollection.setValue(nickname, forKey: "nickname")
            let pokemonData = Utils.getDataFromPokemon(pokemon: pokemon)
            myCollection.setValue(pokemonData, forKey: "pokemon")
            do {
                try managedContext.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
    
    func releasedPokemon(nickname: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Disposables.create() }
            let managedContex = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyBag")
            fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
            do {
                let result = try managedContex.fetch(fetchRequest)
                let objectToDelete = result.first as! NSManagedObject
                managedContex.delete(objectToDelete)
                do {
                    try managedContex.save()
                    observer.onNext(true)
                    observer.onCompleted()
                } catch {
                    print("Failed to delete")
                    observer.onError(DatabaseError.requestFailed)
                }
            } catch {
                print("Failed retrieve")
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
    
    func getMyBags() -> Observable<[PokemonBag]> {
        return Observable<[PokemonBag]>.create { observer in
            var collections: [PokemonBag] = []
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return Disposables.create() }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyBag")
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    guard let nickname = data.value(forKey: "nickname") as? String, let pokemonData = data.value(forKey: "pokemon") as? Data, let pokemon = Utils.getPokemonFromData(data: pokemonData) else { continue }
                    let bag = PokemonBag(nickname: nickname, pokemon: pokemon)
                    collections.append(bag)
                }
                observer.onNext(collections)
                observer.onCompleted()
            } catch {
                print("Failed retrieve")
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .requestFailed: return "Your request failed."
        }
    }
}

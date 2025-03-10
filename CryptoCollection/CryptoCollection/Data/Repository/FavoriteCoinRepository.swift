//
//  CoinDataRepository.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation
import RealmSwift

protocol FavoriteCoinRepositoryProtocol {
    func getFileURL()
    func getAll() -> Results<FavoriteCoin>
    func createItem(favoriteCoin: FavoriteCoin)
    func deleteItem(favoriteCoin: FavoriteCoin)
    func isItemInRealm(id: String) -> Bool
}

final class FavoriteCoinRepository: FavoriteCoinRepositoryProtocol {
    
    private let realm = try! Realm()

    func getFileURL() { print(realm.configuration.fileURL as Any) }

    func getAll() -> Results<FavoriteCoin> {
        return realm.objects(FavoriteCoin.self)
    }

    func isItemInRealm(id: String) -> Bool {
        return realm.objects(FavoriteCoin.self).filter("id == %@", id).first != nil
    }

    func createItem(favoriteCoin: FavoriteCoin) {
        do {
            try realm.write {
                let favCoin = favoriteCoin
                realm.add(favCoin)
                print("Created!!", getFileURL())
            }
        } catch {
            print("Favorite Coin Create Fail")
        }
    }

    func deleteItem(favoriteCoin: FavoriteCoin) {
        do {
            try realm.write {
                let favCoin = favoriteCoin
                realm.delete(favCoin)
                print("Deleted!!")
            }
        } catch {
            print("Favorite Coin Deleted Fail")
        }
    }
}

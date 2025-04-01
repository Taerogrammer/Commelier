//
//  CoinDataRepository.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation
import RealmSwift

protocol OldFavoriteCoinRepositoryProtocol {
    func getFileURL()
    func getAll() -> Results<OldFavoriteCoin>
    func createItem(favoriteCoin: OldFavoriteCoin)
    func deleteItem(favoriteCoin: OldFavoriteCoin)
    func isItemInRealm(id: String) -> Bool
}

final class OldFavoriteCoinRepository: OldFavoriteCoinRepositoryProtocol {
    
    private let realm = try! Realm()

    func getFileURL() { print(realm.configuration.fileURL as Any) }

    func getAll() -> Results<OldFavoriteCoin> {
        return realm.objects(OldFavoriteCoin.self)
    }

    func isItemInRealm(id: String) -> Bool {
        return realm.objects(OldFavoriteCoin.self).filter("id == %@", id).first != nil
    }

    func createItem(favoriteCoin: OldFavoriteCoin) {
        do {
            try realm.write {
                let favCoin = favoriteCoin
                realm.add(favCoin)
            }
        } catch {
            print("Favorite Coin Create Fail")
        }
    }

    func deleteItem(favoriteCoin: OldFavoriteCoin) {
        if let deletedItem = realm.objects(OldFavoriteCoin.self)
            .filter("id == %@", favoriteCoin.id)
            .first {
            do {
                try realm.write {
                    realm.delete(deletedItem)
                }
            } catch {
                print("Favorite Coin Deleted Fail")
            }
        }
    }
}

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
}

final class FavoriteCoinRepository: FavoriteCoinRepositoryProtocol {
    
    private let realm = try! Realm()

    func getFileURL() { print(realm.configuration.fileURL as Any) }

    func getAll() -> Results<FavoriteCoin> {
        return realm.objects(FavoriteCoin.self)
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


}

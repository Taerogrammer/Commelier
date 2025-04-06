//
//  FavoriteCoin.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation
import RealmSwift

final class OldFavoriteCoin: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var symbol: String
    @Persisted var image: String

    convenience init(id: String, symbol: String, image: String) {
        self.init()
        self.id = id
        self.symbol = symbol
        self.image = image
    }

}

//
//  FavoriteCoin.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation
import RealmSwift

final class FavoriteObject: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var image: String?

    var holding: HoldingObject? {
        let realm = try? Realm()
        return realm?.object(ofType: HoldingObject.self, forPrimaryKey: name)
    }

    var transactionQuantity: Decimal128? {
        holding?.transactionQuantity
    }

    var symbol: String? {
        holding?.symbol
    }

    convenience init(name: String, image: String? = nil) {
        self.init()
        self.name = name
        self.image = image
    }
}

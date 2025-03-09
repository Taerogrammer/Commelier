//
//  FavoriteCoin.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation
import RealmSwift

final class FavoriteCoin: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var symbol: String
    @Persisted var market_cap_rank: Int?
    @Persisted var thumb: String

    convenience init(id: String, name: String, symbol: String, market_cap_rank: Int? = nil, thumb: String) {
        self.init()
        self.id = id
        self.name = name
        self.symbol = symbol
        self.market_cap_rank = market_cap_rank
        self.thumb = thumb
    }

}

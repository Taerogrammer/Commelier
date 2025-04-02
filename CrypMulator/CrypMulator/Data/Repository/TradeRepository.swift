//
//  TradeRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

final class TradeRepository: TradeRepositoryProtocol {
    private let realm = try! Realm()

    func getAllTrade() -> [TradeDTO] {
        let trades = realm.objects(TradeObject.self)
        return trades.map { $0.toDTO() }
    }
}

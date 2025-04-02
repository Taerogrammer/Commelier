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

    func trade(_ entity: TradeEntity) {
        let dto = entity.toDTO()
        let object = TradeObject(
            name: dto.name,
            buySell: dto.buySell,
            transactionQuantity: Decimal128(value: dto.transactionQuantity),
            price: Decimal128(value: dto.price),
            timestamp: dto.timestamp
        )
        do {
            try realm.write {
                realm.add(object)
                print("✅ 거래 완료: \(dto.name) => \(dto.buySell)")
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }

}

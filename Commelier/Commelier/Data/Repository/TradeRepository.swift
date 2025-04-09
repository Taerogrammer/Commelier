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

    func getAllTrade() -> [TradeEntity] {
        let trades = realm.objects(TradeObject.self)
        return trades.map { $0.toEntity() }
    }

    func trade(_ entity: TradeEntity) {
        let object = entity.toObject()
        do {
            try realm.write {
                realm.add(object)
                print("✅ 거래 완료: \(entity.name) => \(entity.buySell)")
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }

}

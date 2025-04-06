//
//  HoldingRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

final class HoldingRepository: HoldingRepositoryProtocol {
    private let realm = try! Realm()

    func getHolding() -> [HoldingDTO] {
        let objects = realm.objects(HoldingObject.self)
        return objects.map { $0.toDTO() }
    }

    func getHoldingMarket(name: String) -> HoldingDTO? {
        let object = realm.objects(HoldingObject.self)
            .filter("name == %@", name, name)
            .first

        return object?.toDTO()
    }

    func saveTradeResult(_ entity: TradeEntity) {
        do {
            try realm.write {
                if entity.buySell.lowercased() == "buy" { handleBuy(entity) }
                else { handleSell(entity) }
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }

    private func handleBuy(_ entity: TradeEntity) {
        if let holding = realm.object(ofType: HoldingObject.self, forPrimaryKey: entity.name) {
            holding.totalBuyPrice += entity.price
            holding.transactionQuantity += Decimal128(value: entity.transactionQuantity)
        } else {
            realm.add(entity.toHoldingDTO().toObject())
            print("✅ 새 보유 생성: \(entity.name)")
        }
    }

    private func handleSell(_ entity: TradeEntity) {
        guard let holding = realm.object(ofType: HoldingObject.self, forPrimaryKey: entity.name) else { return }

        // 매도 수량
        let quantitySold = entity.transactionQuantity
        // 판매 후 남은 수량 (기존 수량 - 매도 수량)
        let remainingQuantity = holding.transactionQuantity.toDecimal() - quantitySold

        // 기존 평균 단가
        let avgBuyPrice = Int64.toDecimal(holding.totalBuyPrice) / holding.transactionQuantity.toDecimal()

        // 남은 수량이 없다면 Realm에서 삭제
        if remainingQuantity <= 0 {
            print("🗑 전체 매도: \(entity.name)")
            realm.delete(holding)
        } else {
            // 남은 수량(기존 수량 - 매도 수량)을 반영한 구매 총합
            let remainingTotalBuyPrice = avgBuyPrice * remainingQuantity

            holding.transactionQuantity = Decimal128(value: remainingQuantity)
            holding.totalBuyPrice = remainingTotalBuyPrice.toInt64Rounded()

            // ✅ 로그 출력
            print("📉 매도 후 남은 수량: \(remainingQuantity)")
            print("💰 매도 후 남은 총 매수금액: \(remainingTotalBuyPrice)")
            print("holding.totalBuyPrice:", holding.totalBuyPrice)

            // 방어 로직
            let epsilon = Decimal128(0.00000001)
            if holding.transactionQuantity < epsilon || holding.totalBuyPrice <= 1 {
                realm.delete(holding)
            }
        }
    }
}

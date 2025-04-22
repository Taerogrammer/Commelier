//
//  HoldingRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import NumberterKit
import RealmSwift
import WidgetKit

final class HoldingRepository: HoldingRepositoryProtocol {
    private let realm = try! Realm()

    func getHolding() -> [HoldingEntity] {
        let objects = realm.objects(HoldingObject.self)
        return objects.map { $0.toEntity() }
    }

    func getHoldingMarket(name: String) -> HoldingEntity? {
        let object = realm.objects(HoldingObject.self)
            .filter("name == %@", name, name)
            .first

        return object?.toEntity()
    }

    func saveTradeResult(_ entity: TradeEntity) {
        do {
            try realm.write {
                if entity.buySell.lowercased() == "buy" { handleBuy(entity) }
                else { handleSell(entity) }
                saveTopHoldingsToWidget()
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
            realm.add(entity.toHoldingEntity().toObject())
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
        let avgBuyPrice = holding.totalBuyPrice.decimalValue / holding.transactionQuantity.toDecimal()

        // 남은 수량이 없다면 Realm에서 삭제
        if remainingQuantity <= 0 {
            print("🗑 전체 매도: \(entity.name)")
            realm.delete(holding)
        } else {
            // 남은 수량(기존 수량 - 매도 수량)을 반영한 구매 총합
            let remainingTotalBuyPrice = avgBuyPrice * remainingQuantity

            holding.transactionQuantity = Decimal128(value: remainingQuantity)
            holding.totalBuyPrice = remainingTotalBuyPrice.toRoundedInt64()

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

    private func saveTopHoldingsToWidget() {
        let holdings = realm.objects(HoldingObject.self)
            .sorted(byKeyPath: "transactionQuantity", ascending: false)
            .map { $0.toWidgetModel() }

        print("🧾 저장될 위젯 데이터:")
        holdings.forEach { print("- \($0.symbol): \($0.amount)") }

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(Array(holdings)) {
            let defaults = UserDefaults(suiteName: "group.commelier.coin.holding") // App Group ID
            defaults?.set(data, forKey: "holdings")
            WidgetCenter.shared.reloadAllTimelines()
            print("✅ 위젯용 Top 보유 저장 완료")
        } else {
            print("❌ 위젯 데이터 인코딩 실패")
        }
    }
}

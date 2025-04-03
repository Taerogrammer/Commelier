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

    // TODO: - 매도할 때 로직 확인해보기,,!
    // TODO: - 평가금액 - 판매가격으로 업데이트 해야됨!!!!!!
    func getHoldingMarket(name: String) -> HoldingDTO? {
        let object = realm.objects(HoldingObject.self)
            .filter("name == %@", name, name)
            .first

        return object?.toDTO()
    }

    func saveTradeResult(_ entity: TradeEntity) {
        do {
            try realm.write {
                let holdingExist = realm.objects(HoldingObject.self)
                    .filter("name == %@", entity.name)
                    .first

                // 보유 목록이 존재한다면
                if let holdingExist = holdingExist {
                    if entity.buySell.lowercased() == "buy" {
                        // 매수인 경우: 총 매수 금액(TotalBuyPrice) 및 수량(TransactionQuantity) 증가
                        holdingExist.totalBuyPrice += entity.price
                        holdingExist.transactionQuantity +=  Decimal128(value: entity.transactionQuantity)
                    } else {
                        // 매수인 경우: 총 매수 금액(TotalBuyPrice) 및 수량(TransactionQuantity) 감소
                        holdingExist.totalBuyPrice -= entity.price
                        holdingExist.transactionQuantity -= Decimal128(value: entity.transactionQuantity)

                        // TODO: - 조금 남아있을 수 있는 경우 처리하기 (판매해도 DB에 찌꺼기? 저장되어있음)
                        let epsilon = Decimal128(0.00000001) // 충분히 작은 값 설정
                        // 수량이 0 이하가 되면 해당 보유 자산 삭제
                        if holdingExist.transactionQuantity <= 0 || holdingExist.transactionQuantity < epsilon || holdingExist.totalBuyPrice <= 0 {
                            realm.delete(holdingExist)
                        }
                    }
                } else {    // 보유 자산이 없는 경우
                    if entity.buySell.lowercased() == "buy" {
                        realm.add(entity.toHoldingDTO().toObject())
                        print("✅ 저장 완료: \(entity.toHoldingDTO())")
                    }
                }
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }
}

//
//  ChargeRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

protocol ChargeRepositoryProtocol: AnyObject {
    func getFileURL()
    func saveCharge(amount: Decimal)
}

final class ChargeRepository: ChargeRepositoryProtocol {
    private let realm = try! Realm()

    func getFileURL() { print(realm.configuration.fileURL as Any) }

    func saveCharge(amount: Decimal) {
        let now = Int64(Date().timeIntervalSince1970)
        let charge = ChargeObject(chargeAmount: amount, timestamp: now)

        do {
            try realm.write {
                realm.add(charge)
                print("✅ 충전 내역 저장 완료: \(amount)원 at \(now)")
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }
}

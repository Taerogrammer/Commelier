//
//  ChargeRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

final class ChargeRepository: ChargeRepositoryProtocol {
    private let realm = try! Realm()

    func getFileURL() {
        print(realm.configuration.fileURL as Any)
    }

    func saveCharge(_ entity: ChargeEntity) {
        let object = ChargeObject(
            chargeAmount: entity.amount,
            timestamp: entity.timestamp
        )
        do {
            try realm.write {
                realm.add(object)
                print("✅ 충전 저장 완료: \(entity.amount)원 at \(entity.timestamp)")
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }

    func fetchAllCharges() -> [ChargeEntity] {
        let results = realm.objects(ChargeObject.self)
        return results.map { $0.toEntity() }
    }
}

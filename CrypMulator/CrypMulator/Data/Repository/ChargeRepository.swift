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

    func saveCharge(_ dto: ChargeDTO) {
        let object = ChargeObject(
            chargeAmount: dto.amount,
            timestamp: dto.timestamp
        )
        do {
            try realm.write {
                realm.add(object)
                print("✅ 충전 저장 완료: \(dto.amount)원 at \(dto.timestamp)")
            }
        } catch {
            print("❌ Realm 저장 실패: \(error)")
        }
    }

    func fetchAllCharges() -> [ChargeDTO] {
        let results = realm.objects(ChargeObject.self)
        return results.map { $0.toDTO() }
    }
}

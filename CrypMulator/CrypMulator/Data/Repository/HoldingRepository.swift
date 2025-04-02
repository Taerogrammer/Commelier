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

    func getHoldingMarket(name: String) -> HoldingDTO? {
        let object = realm.objects(HoldingObject.self)
            .filter("name == %@", name, name)
            .first

        return object?.toDTO()
    }
}

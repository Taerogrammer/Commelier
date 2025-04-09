//
//  ChargeRepositoryProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol ChargeRepositoryProtocol: AnyObject {
    func getFileURL()
    func saveCharge(_ entity: ChargeEntity)
    func fetchAllCharges() -> [ChargeEntity]
}

//
//  CurrentAssetUseCaseProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol CurrentCurrencyUseCaseProtocol: AnyObject {
    func getCurrentCurrency() -> Decimal
}

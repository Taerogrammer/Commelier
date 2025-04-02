//
//  PortfolioRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation

protocol PortfolioSummaryRepositoryProtocol: AnyObject {
    func getFileURL()
    func getSummary(currentPrices: [String: Decimal]) -> PortfolioSummaryEntity
}

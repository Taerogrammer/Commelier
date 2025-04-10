//
//  SystemColor.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import UIKit

//enum SystemColor {
//    static let black       = UIColor(hex: "#1E1B1A")  // 소믈리에 다크 블랙
//    static let gray        = UIColor(hex: "#3C342F")  // 딥 브론즈 그레이
//    static let whiteGray   = UIColor(hex: "#C4C6CA")  // 중립 회색
//    static let darkBrown   = UIColor(hex: "#2B2624")  // 초콜릿톤 카드
//    static let darkGreen = UIColor(hex: "#456D5A") // 딥 그린
//    static let green       = UIColor(hex: "#416B56")  // 짙은 다크 올리브
//    static let whiteGreen  = UIColor(hex: "#2B332C")  // 강조 배경용 어두운 그린
//    static let red         = UIColor(hex: "#872E2E")  // 짙은 와인빛 버건디
//    static let gold        = UIColor(hex: "#C2A96B")  // 샴페인 골드 느낌
//    static let bronze  = UIColor(hex: "#A96F4C") // 브론즈/테라코타톤
//    static let white       = UIColor(hex: "#F4F1EC")  // 따뜻한 화이트
//}


enum SystemColor {

    // MARK: - Dynamic Colors (라이트/다크 자동 전환)

    static let background = UIColor.dynamicColor(
        light: "#F4F1EC",  // 따뜻한 화이트
        dark: "#1E1B1A"    // 소믈리에 다크 블랙
    )

    static let label = UIColor.dynamicColor(
        light: "#1E1E1E",  // 블랙
        dark: "#F4F1EC"    // 따뜻한 화이트
    )

    static let gray = UIColor.dynamicColor(
        light: "#C4C6CA",  // 중립 회색
        dark: "#3C342F"    // 딥 브론즈 그레이
    )

    static let card = UIColor.dynamicColor(
        light: "#FFFFFF",  // 기본 카드
        dark: "#2B2624"    // 초콜릿톤 카드
    )

    static let green = UIColor.dynamicColor(
        light: "#416B56",  // 짙은 다크 올리브
        dark: "#456D5A"    // 딥 그린
    )

    static let whiteGreen = UIColor.dynamicColor(
        light: "#EBF0EB",  // 라이트 강조
        dark: "#2B332C"    // 강조 배경용 어두운 그린
    )

    static let red = UIColor.dynamicColor(
        light: "#872E2E",  // 짙은 와인빛
        dark: "#B94E4E"    // 조금 밝은 버건디
    )

    static let gold = UIColor.dynamicColor(
        light: "#C2A96B",  // 샴페인 골드
        dark: "#A18652"
    )

    static let bronze = UIColor.dynamicColor(
        light: "#A96F4C",
        dark: "#804D33"
    )
}

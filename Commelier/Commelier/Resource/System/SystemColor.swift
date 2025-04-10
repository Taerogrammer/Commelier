//
//  SystemColor.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import UIKit

enum SystemColor {

    // MARK: - Dynamic Colors (라이트/다크 자동 전환)

    static let background = UIColor.dynamicColor(
        light: "#F4F1EC",  // 따뜻한 화이트
        dark: "#1E1B1A"    // 소믈리에 다크 블랙
    )

    static let label = UIColor.dynamicColor(
        light: "#1E1E1E",  // 진한 블랙
        dark: "#F4F1EC"    // 따뜻한 화이트
    )

    static let secondaryText = UIColor.dynamicColor(
        light: "#7A7A7A",   // 진한 회색
        dark: "#868686"     // 다크 모드에서는 중간톤 유지
    )

    // MARK: - Grayscale

    static let panelBackground = UIColor.dynamicColor(
        light: "#D6CFC9",   // 따뜻한 웜 그레이 (C4C6CA보다 부드럽고 자연스러움)
        dark: "#3C342F"     // 기존 딥 브론즈 그레이 유지
    )
    static let card = UIColor.dynamicColor(
        light: "#FFFFFF",  // 카드용 밝은 배경
        dark: "#2B2624"    // 초콜릿톤 카드
    )

    // MARK: - Theme Accent Colors

    static let green = UIColor.dynamicColor(
        light: "#2F8F5B",  // 더 선명하고 진한 초록
        dark: "#456D5A"    // 딥 그린 (기존 유지)
    )

    static let red = UIColor.dynamicColor(
        light: "#D34040",  // 더 강렬한 레드
        dark: "#B94E4E"    // 부드러운 버건디
    )

    static let bronze = UIColor.dynamicColor(
        light: "#C9793D",  // 더 선명한 테라코타
        dark: "#804D33"    // 어두운 브론즈
    )

    static let gold = UIColor.dynamicColor(
        light: "#E7C176",  // 더 샤이니한 골드
        dark: "#A18652"    // 클래식 골드
    )

    static let whiteGreen = UIColor.dynamicColor(
        light: "#D8F1E2",  // 밝은 민트
        dark: "#2B332C"    // 다크 민트
    )

    static let divider = UIColor.dynamicColor(
        light: "#1E1E1E",  // 라이트 모드에서는 블랙 계열
        dark: "#C4C6CA"    // 다크 모드에서는 밝은 회색
    )

    // MARK: - 고정 색상
    static let buttonText = UIColor(hex: "#F4F1EC")
    static let black = UIColor(hex: "#000000")
}

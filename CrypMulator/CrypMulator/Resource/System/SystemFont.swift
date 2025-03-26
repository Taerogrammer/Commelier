import UIKit

enum SystemFont {

    // MARK: - Display & Headlines
    enum Title {
        static let large       = UIFont.systemFont(ofSize: 28, weight: .bold)   // 현재가, 총자산
        static let medium      = UIFont.systemFont(ofSize: 20, weight: .bold)   // 상세 제목
        static let small       = UIFont.systemFont(ofSize: 16, weight: .bold)   // 섹션 제목
    }

    // MARK: - Labels & Descriptions
    enum Body {
        static let primary      = UIFont.systemFont(ofSize: 14, weight: .regular)    // 지표
        static let boldPrimary  = UIFont.systemFont(ofSize: 14, weight: .bold)      // 지표 + 강조
        static let content      = UIFont.systemFont(ofSize: 12, weight: .regular)        // 라벨
        static let boldContent  = UIFont.systemFont(ofSize: 12, weight: .bold)   // 라벨 + 강조
        static let small        = UIFont.systemFont(ofSize: 9, weight: .regular)     // 날짜, 회색 라벨
        static let boldSmall    = UIFont.systemFont(ofSize: 9, weight: .bold)        // 강조 수치
    }

    // MARK: - Buttons
    enum Button {
        static let primary     = UIFont.systemFont(ofSize: 16, weight: .bold)    // 매수/매도
        static let secondary   = UIFont.systemFont(ofSize: 14, weight: .medium)  // % 버튼 등
    }

    // MARK: - Navigation
    enum Navigation {
        static let title       = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
}

//
//  SettingFactory.swift
//  Commelier
//
//  Created by 김태형 on 4/10/25.
//

import UIKit

struct SettingFactory {
    private init() {}
    static func make() -> SettingViewController {
        return SettingViewController()
    }
}

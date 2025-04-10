//
//  UserDefaultsManager.swift
//  Commelier
//
//  Created by 김태형 on 4/10/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }

    func removeObject() { storage.removeObject(forKey: key) }
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}

    enum Key: String {
        case selectedTheme
    }

    @UserDefault(key: Key.selectedTheme.rawValue, defaultValue: ThemeManager.Theme.system.rawValue, storage: .standard)
    private var themeRawValue: String

    var selectedTheme: ThemeManager.Theme {
        get { ThemeManager.Theme(rawValue: themeRawValue) ?? .system }
        set { themeRawValue = newValue.rawValue }
    }
}

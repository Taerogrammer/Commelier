//
//  SettingViewController.swift
//  Commelier
//
//  Created by 김태형 on 4/10/25.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func configureHierarchy() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ThemeCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        title = StringLiteral.Setting.title
        view.backgroundColor = SystemColor.background
        tableView.backgroundColor = SystemColor.background
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThemeManager.Theme.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = ThemeManager.Theme.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = theme.description
        content.image = theme.icon
        content.imageProperties.tintColor = .label
        content.textProperties.font = SystemFont.Body.primary

        cell.contentConfiguration = content
        cell.backgroundColor = SystemColor.panelBackground
        cell.accessoryType = (theme == ThemeManager.shared.currentTheme) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTheme = ThemeManager.Theme.allCases[indexPath.row]
        ThemeManager.shared.applyTheme(to: view.window, theme: selectedTheme)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StringLiteral.Setting.themeSectionTitle
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}

final class ThemeManager {
    static let shared = ThemeManager()

    enum Theme: String, CaseIterable {
        case system, light, dark

        var description: String {
            switch self {
            case .system: return StringLiteral.Setting.systemMode
            case .light: return StringLiteral.Setting.lightMode
            case .dark: return StringLiteral.Setting.darkMode
            }
        }

        var icon: UIImage {
            switch self {
            case .system: return SystemIcon.themeSystem
            case .light: return SystemIcon.themeLight
            case .dark: return SystemIcon.themeDark
            }
        }
    }

    private(set) var currentTheme: Theme = .system

    func applyTheme(to window: UIWindow?, theme: Theme) {
        currentTheme = theme
        UserDefaultsManager.shared.selectedTheme = theme

        switch theme {
        case .light:
            window?.overrideUserInterfaceStyle = .light
        case .dark:
            window?.overrideUserInterfaceStyle = .dark
        case .system:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }

    func loadTheme() -> Theme {
        let theme = UserDefaultsManager.shared.selectedTheme
        currentTheme = theme
        return theme
    }
}

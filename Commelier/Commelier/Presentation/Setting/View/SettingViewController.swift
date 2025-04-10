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
        title = "설정"
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
        content.image = UIImage(systemName: theme.iconName)
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
        return "화면 설정"
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}

final class ThemeManager {
    static let shared = ThemeManager()

    enum Theme: CaseIterable {
        case system, light, dark

        var description: String {
            switch self {
            case .system: return "사용자 설정 따르기"
            case .light: return "라이트 모드"
            case .dark: return "다크 모드"
            }
        }

        var iconName: String {
            switch self {
            case .system: return "gearshape"
            case .light: return "sun.max"
            case .dark: return "moon.stars"
            }
        }
    }

    var currentTheme: Theme = .dark

    func applyTheme(to window: UIWindow?, theme: Theme) {
        currentTheme = theme
        switch theme {
        case .light:
            window?.overrideUserInterfaceStyle = .light
        case .dark:
            window?.overrideUserInterfaceStyle = .dark
        case .system:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
}


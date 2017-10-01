//
//  MeViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class MeViewController: UITableViewController {
    let CELL_ID = "MeViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我"

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        tableView.register(MeViewCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.theme_backgroundColor = globalSpaceColorPicker
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [30, 50, 50, 12, 50, 50, 12, 50][indexPath.row]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MeViewCell
        cell.selectionStyle = .none

        cell.titleLabel.text = [
            "",
            "我的收藏",
            "阅读历史",
            "",
            "关于我们",
            "源代码",
            "",
            "设置"
            ][indexPath.row]

        if [0, 3, 6].contains(indexPath.row) {
            cell.theme_backgroundColor = globalSpaceColorPicker
        } else {
            cell.theme_backgroundColor = globalBackgroundColorPicker
        }

        if [0, 3, 6].contains(indexPath.row) {
            cell.detailMarkHidden = true
        } else {
            cell.detailMarkHidden = false
        }

        cell.detailLabel.text = ""

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let starViewController = StarViewController()
            self.navigationController?.pushViewController(starViewController, animated: true)
        case 2:
            let historyViewController = HistoryViewController()
            self.navigationController?.pushViewController(historyViewController, animated: true)
        case 4: break
        case 5:
            UIApplication.shared.open(URL(string: "https://github.com/vimrus/Hubble")!, options: [:], completionHandler: nil)
        case 7:
            let settingsViewController = SettingsViewController()
            self.navigationController?.pushViewController(settingsViewController, animated: true)
        default: break
        }
    }
}

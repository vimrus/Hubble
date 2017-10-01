//
//  SettingsViewController.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let Theme_CELL_ID = "ThemeViewCell"
    let FONT_SIZE_CELL_ID = "FontSizeViewCell"
    let FONT_DISPLAY_CELL_ID = "FontDisplayViewCell"
    let FONT_SPACE_CELL_ID = "MeViewCell"

    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        tableView.theme_backgroundColor = globalSpaceColorPicker

        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(view)
        }

        tableView.register(ThemeViewCell.self, forCellReuseIdentifier: Theme_CELL_ID)
        tableView.register(FontSizeViewCell.self, forCellReuseIdentifier: FONT_SIZE_CELL_ID)
        tableView.register(MeViewCell.self, forCellReuseIdentifier: FONT_SPACE_CELL_ID)
        tableView.register(FontDisplayViewCell.self, forCellReuseIdentifier: FONT_DISPLAY_CELL_ID)

        tableView.delegate = self
        tableView.dataSource = self

        //        self.thmemChangedHandler = {[weak self] (style) -> Void in
        //            self?.view.backgroundColor = V2EXColor.colors.v2_backgroundColor
        //            self?.tableView.reloadData()
        //        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 3][section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.theme_backgroundColor = globalBackgroundColorPicker
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = [
            "    主题 - 点击选择下方风格主题",
            "    字体 - 移动滑块调整字体大小"
            ][section]

        label.textColor = fixColor(0x000000)
        label.font = fixFont(12)
        label.theme_backgroundColor = globalSpaceColorPicker
        return label
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        } else {
            return [60, 25, 220][indexPath.row]
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Theme_CELL_ID, for: indexPath) as! ThemeViewCell
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FONT_SIZE_CELL_ID.self, for: indexPath) as! FontSizeViewCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FONT_SPACE_CELL_ID.self, for: indexPath) as! MeViewCell
                cell.backgroundColor = fixColor(0xFDFDFD)
                cell.detailMarkHidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: FONT_DISPLAY_CELL_ID.self, for: indexPath) as! FontDisplayViewCell
                cell.backgroundColor = UIColor.white
                return cell
            }
        }
    }
}

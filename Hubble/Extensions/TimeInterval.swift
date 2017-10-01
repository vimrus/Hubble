//
//  TimeInterval.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toString(format: String) -> String {
        let date = Date(timeIntervalSince1970: self)

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "CST")

        return formatter.string(from: date)
    }

    private func dateComponents() -> DateComponents {
        let date = Date(timeIntervalSince1970: self)
        let now = Date()

        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]

        return (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    }

    func timeAgo() -> String {
        let components = dateComponents()

        if let year = components.year, year >= 2 {
            return "\(year)年前"
        }

        if let year = components.year, year >= 1 {
            return "去年"
        }

        if let month = components.month, month >= 2 {
            return "\(month)个月前"
        }

        if let month = components.month, month >= 1 {
            return "上月"
        }

        if let week = components.weekOfYear, week >= 2 {
            return "\(week)周前"
        }

        if let week = components.weekOfYear, week >= 1 {
            return "上周"
        }

        if let day = components.day, day >= 2 {
            return "\(day)天前"
        }

        if let day = components.day, day >= 1 {
            return "昨天"
        }

        if let hour = components.hour, hour >= 2 {
            return "\(hour)小时前"
        }

        if let hour = components.hour, hour >= 1 {
            return "1小时前"
        }

        if let minute = components.minute, minute >= 2 {
            return "\(minute)分钟前"
        }

        if let minute = components.minute, minute >= 1 {
            return "1分钟前"
        }

        return "刚刚"
    }
}

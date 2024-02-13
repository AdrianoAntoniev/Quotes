//
//  UIFont+.swift
//  Quotes
//
//  Created by Adriano Rodrigues Vieira on 12/02/24.
//

import UIKit

extension UIFont {
    static let timesNewRoman15 = UIFont(name: .timesNewRomanBold, size: .s15)
    static let timesNewRoman18 = UIFont(name: .timesNewRomanBold, size: .s18)
    static let timesNewRomanItalic13 = UIFont(name: .timesNewRomanItalic, size: .s13)
}

fileprivate extension String {
    static let timesNewRomanBold: Self = "TimesNewRomanPS-BoldMT"
    static let timesNewRomanBoldItalic: Self = "TimesNewRomanPS-BoldItalicMT"
    static let timesNewRomanItalic: Self = "TimesNewRomanPS-ItalicMT"
    static let timesNewRoman: Self = "TimesNewRomanPSMT"
}

fileprivate extension CGFloat {
    static let s13: Self = 13
    static let s15: Self = 15
    static let s18: Self = 18
}

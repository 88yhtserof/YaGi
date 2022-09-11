//
//  ExUIFont.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/11.
//

import UIKit

extension UIFont {
    enum MaruburiWeight: String {
        case bold = "MaruBuri-Bold"
        case semiBold = "MaruBuri-SemiBold"
        case regular = "MaruBuri-Regular"
        case light = "MaruBuri-Light"
        case extraLight = "MaruBuri-ExtraLight"
    }
    
    static func maruburi(ofSize fontSize: CGFloat, weight: UIFont.MaruburiWeight) -> UIFont {
        let font = UIFont(name: weight.rawValue, size: fontSize)
        
        return font ?? UIFont.systemFont(ofSize: 13, weight: .regular)
    }
}

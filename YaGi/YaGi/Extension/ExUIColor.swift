//
//  ExUIColor.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/17.
//

import UIKit

extension UIColor {
    
    //MARK: - YaGi Color
    //Some convenience methods to create YaGi colors.
    class var yagiHighlight: UIColor { return UIColor(named: "YaGi_highlight") ?? .label }
    
    class var yagiHighlightLight: UIColor { return UIColor(named: "YaGi_highlight_light") ?? .label }
    
    class var yagiWhite: UIColor { return UIColor(named: "YaGi_white") ?? .label }
    
    class var yagiWhihtDeep: UIColor { return UIColor(named: "YaGi_white_deep") ?? .label }
    
    class var yagiGray: UIColor { return UIColor(named: "YaGi_gray") ?? .label }
    
    class var yagiGrayLight: UIColor { return UIColor(named: "YaGi_gray_light") ?? .label }
    
    class var yagiGrayDeep: UIColor { return UIColor(named: "YaGi_gray_deep") ?? .label }
    
}

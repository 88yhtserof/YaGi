//
//  ExUIView.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/27.
//

import UIKit

extension UIView {
    
    enum Corner {
        case topLeft, topRight
        case bottomLeft, bottomRight
    }
    
    func roundCorner(round: Int, _ corners: [Corner]){
        self.layer.cornerRadius = CGFloat(round)
        var cornerMasks = CACornerMask()
        
        corners.forEach { corner in
            switch corner {
            case .topLeft:
                cornerMasks.insert(.layerMinXMinYCorner)
            case .topRight:
                cornerMasks.insert(.layerMaxXMinYCorner)
            case .bottomLeft:
                cornerMasks.insert(.layerMinXMaxYCorner)
            case .bottomRight:
                cornerMasks.insert(.layerMaxXMaxYCorner)
            }
        }
        
        self.layer.maskedCorners = cornerMasks
    }
}

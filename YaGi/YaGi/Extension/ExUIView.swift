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
    
    /// Render a Image from view to get a full screen snap shot.
    /// Return UIImage, or nil.
    func snapShotFullScreen(scrollView: UIScrollView) -> UIImage? {
        let savedFrame = self.frame
        let savedScrollviewFrame = scrollView.frame
        let savedContentOffset = scrollView.contentOffset
        let scrollContentFrame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        scrollView.contentOffset = .zero
        scrollView.frame = scrollContentFrame
        self.frame = scrollContentFrame
        
        // Render Image
        let renderer = UIGraphicsImageRenderer(size: self.frame.size)
        let image = renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
        
        // Initialize the set value
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedScrollviewFrame
        self.frame = savedFrame

        return image
    }
}

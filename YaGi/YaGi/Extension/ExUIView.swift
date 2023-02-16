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
    
    func snapShotFullScreen(scrollView: UIScrollView) -> UIImage? {
        let savedFrame = self.frame
        let savedScrollviewFrame = scrollView.frame
        let savedContentOffset = scrollView.contentOffset
        let scrollFrame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        scrollView.contentOffset = .zero
        scrollView.frame = scrollFrame
        self.frame = scrollFrame
        
        //context 생성
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0)
        
        //context에 해당 view 모습 렌더링(이미지화)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)

        //이미지가 그려진 context에서 이미지 가져오기
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        //view와 scrollView 원상복구
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedScrollviewFrame
        self.frame = savedFrame

        //context pop
        UIGraphicsEndImageContext()

        return image
    }
}

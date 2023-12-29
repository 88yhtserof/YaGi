//
//  ExUIActivityViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 12/29/23.
//

import UIKit

extension UIActivityViewController {
    
    /// For universal applications, Initialize a new activity view controller object that can tailor the behavior of your application for a specific type of device.
    convenience init(_ vc: UIViewController, activityItems: [Any], applicationActivities: [UIActivity]?) {
        self.init(activityItems: activityItems, applicationActivities: applicationActivities)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let _X = vc.view.bounds.maxX
            let _Y = (vc.navigationController?.navigationBar.layer.bounds.maxY ?? 0) + CGFloat(30)
            
            self.modalPresentationStyle = .popover
            self.popoverPresentationController?.sourceView = vc.view
            self.popoverPresentationController?.sourceRect.origin = CGPoint(x: _X, y: _Y)
            self.popoverPresentationController?.permittedArrowDirections = .up
        }
    }
    
}

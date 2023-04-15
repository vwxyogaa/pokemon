//
//  UIView+Ext.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit

// MARK: - Get Image
extension UIView {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}

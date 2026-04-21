//
//  File.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 21/04/2026.
//

import Foundation
import UIKit

extension UIView {
    static func animateDefault(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.39) {
            animations()
        }
    }
}

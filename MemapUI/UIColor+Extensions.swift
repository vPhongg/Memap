//
//  UIColor+Extensions.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 14/04/2026.
//

import Foundation
import UIKit

extension UIColor {
    
    func toHexString() -> String? {
        guard let components = cgColor.components else { return nil }
        
        let r = components[0]
        let g = components.count > 1 ? components[1] : r
        let b = components.count > 2 ? components[2] : r
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
    
    func toHexString(includeAlpha: Bool) -> String? {
        guard let components = cgColor.components else { return nil }
        
        let r = components[0]
        let g = components.count > 1 ? components[1] : r
        let b = components.count > 2 ? components[2] : r
        let a = cgColor.alpha
        
        if includeAlpha {
            return String(
                format: "#%02X%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255),
                Int(a * 255)
            )
        } else {
            return String(
                format: "#%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255)
            )
        }
    }
    
}


extension UIColor {
    
    convenience init?(hex: String?) {
        guard var hex else { return nil }
        // Clean string
        hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }
        
        let r, g, b, a: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                ((int >> 8) & 0xF) * 17,
                ((int >> 4) & 0xF) * 17,
                (int & 0xF) * 17,
                255
            )
            
        case 4: // ARGB (16-bit)
            (a, r, g, b) = (
                ((int >> 12) & 0xF) * 17,
                ((int >> 8) & 0xF) * 17,
                ((int >> 4) & 0xF) * 17,
                (int & 0xF) * 17
            )
            
        case 6: // RRGGBB (24-bit)
            (r, g, b, a) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF,
                255
            )
            
        case 8: // RRGGBBAA (32-bit)
            (r, g, b, a) = (
                (int >> 24) & 0xFF,
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
            
        default:
            return nil
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
}

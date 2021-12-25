//
//  AQMIndexClassifier.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

import UIKit
//Enum for Air Quality Monitor Index
enum AQMIndexClassification: String, CaseIterable {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor = "very poor"
    case severe
    case outOfRange
}

class AQMIndexClassifier {
    //Based on AQI range get AQI enum
    static func classifyAirQualityIndex(aqi: Float) -> AQMIndexClassification {
        switch aqi {
        case 0.00...50.99:
            return .good
        case 51.00...100.99:
            return .satisfactory
        case 101.00...200.99:
            return .moderate
        case 201.00...300.99:
            return .poor
        case 301.00...400.99:
            return .veryPoor
        case 401.00...500:
            return .severe
        default:
            return .outOfRange
        }
    }
}

struct AQMIndexColorClassifier {
    //Based on AQI enum get color
    static func color(index: AQMIndexClassification) -> UIColor? {
        switch index {
        case .good:
            return UIColor(hex: "#4CA24E")
        case .satisfactory:
            return UIColor(hex: "#99C457")
        case .moderate:
            return UIColor(hex: "#FFFA50")
        case .poor:
            return UIColor(hex: "#EF8F40")
        case .veryPoor:
            return UIColor(hex: "#E52536")
        case .severe:
            return UIColor(hex: "#A51B27")
        case .outOfRange:
            return UIColor(hex: "#8B0000")
        }
    }
}

//UIColor extension
extension UIColor {
    //From hex string get UIColor
    public convenience init?(hex: String) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        var hexColor = hex
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        }
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if hexColor.count == 8 {
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
            }
        } else if hexColor.count == 6 {
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
            }
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

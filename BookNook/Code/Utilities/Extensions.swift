//
//  Extensions.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import SwiftUI
import UIKit
import CoreImage

extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Color {
    static let pinkColor = Color(red: 227 / 255, green: 133 / 255, blue: 180 / 255)
    static let purpleColor = Color(red: 123 / 255, green: 119 / 255, blue: 233 / 255)
    static let OrangeColor = Color(red: 240 / 255, green: 146 / 255, blue: 171 / 255)
    static let textColor = Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255)
    static let subtextColor = Color(red: 199 / 255, green: 199 / 255, blue: 199 / 255)
    static let lightShadow = Color(red: 43 / 255, green: 43 / 255, blue: 43 / 255)
    static let darkShadow = Color(red: 80 / 255, green: 80 / 255, blue: 80 / 255)
    static let lightPink = Color(red: 236 / 255, green: 188 / 255, blue: 180 / 255)
    static let lightGray = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let lightOrange = Color(red: 219 / 255, green: 98 / 255, blue: 68 / 255)
    static let iconGray = Color(red: 112 / 255, green: 112 / 255, blue: 112 / 255)
    static let lighterPink = Color(red: 233 / 255, green: 219 / 255, blue: 210 / 255)
    static let lighterGray = Color(red: 214 / 255, green: 214 / 255, blue: 214 / 255)
    static let flatDarkBackground = Color(red: 36 / 255, green: 36 / 255, blue: 36 / 255)
    static let flatDarkCardBackground = Color(red: 46 / 255, green: 46 / 255, blue: 46 / 255)

}


extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
// MARK: Allows for percentage based layouts
struct SizeCalculator: ViewModifier {
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader {
                    proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}
extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Date {
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

// DateFormatter extension for convenience
extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

extension Color {
    static let beige = Color(red: 200 / 255, green: 200 / 255, blue: 180 / 255)
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension UIImage {
    func getColors() -> [UIColor] {
        guard let inputImage = CIImage(image: self) else { return [] }
        
        // Create a Core Image context
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        // Create a bitmap representation
        let width = Int(inputImage.extent.width)
        let height = Int(inputImage.extent.height)
        var bitmap = [UInt8](repeating: 0, count: width * height * 4)
        
        context.render(inputImage, toBitmap: &bitmap, rowBytes: width * 4, bounds: inputImage.extent, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        // Create a dictionary to count occurrences of each color
        var colorCounts: [UIColor: Int] = [:]
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * 4
                let r = bitmap[offset]
                let g = bitmap[offset + 1]
                let b = bitmap[offset + 2]
                let a = bitmap[offset + 3]
                
                let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
                
                colorCounts[color, default: 0] += 1
            }
        }
        
        // Sort colors by frequency
        let sortedColors = colorCounts.sorted { $0.value > $1.value }
        
        return sortedColors.map { $0.key }
    }
}

//extension UIImage {
//    func getMainColors() -> (UIColor, UIColor)? {
//        guard let inputImage = CIImage(image: self) else { return nil }
//        
//        let context = CIContext(options: [.workingColorSpace: kCFNull!])
//        let width = Int(inputImage.extent.width)
//        let height = Int(inputImage.extent.height)
//        var bitmap = [UInt8](repeating: 0, count: width * height * 4)
//        
//        context.render(inputImage, toBitmap: &bitmap, rowBytes: width * 4, bounds: inputImage.extent, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
//        
//        var colorCounts: [UIColor: Int] = [:]
//        
//        for y in 0..<height {
//            for x in 0..<width {
//                let offset = (y * width + x) * 4
//                let r = bitmap[offset]
//                let g = bitmap[offset + 1]
//                let b = bitmap[offset + 2]
//                let a = bitmap[offset + 3]
//                
//                let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
//                
//                colorCounts[color, default: 0] += 1
//            }
//        }
//        
//        let sortedColors = colorCounts.sorted { $0.value > $1.value }
//        
//        guard sortedColors.count >= 2 else {
//            return nil
//        }
//        
//        let primaryColor = sortedColors[0].key
//        var secondaryColor = sortedColors[1].key
//        
//        // Ensure secondary color is distinct
//        for color in sortedColors.dropFirst(1).map({ $0.key }) {
//            if isColorDistinct(primaryColor, from: color) {
//                secondaryColor = color
//                break
//            }
//        }
//        
//        return (primaryColor, secondaryColor)
//    }
//    
//    private func isColorDistinct(_ color1: UIColor, from color2: UIColor) -> Bool {
//        let hsl1 = color1.hsl
//        let hsl2 = color2.hsl
//        
//        // Check if the hue difference is significant
//        let hueDifference = abs(hsl1.hue - hsl2.hue)
//        if hueDifference > 0.1 {
//            return true
//        }
//        
//        // Check if the saturation difference is significant
//        let saturationDifference = abs(hsl1.saturation - hsl2.saturation)
//        if saturationDifference > 0.2 {
//            return true
//        }
//        
//        // Check if the lightness difference is significant
//        let lightnessDifference = abs(hsl1.lightness - hsl2.lightness)
//        if lightnessDifference > 0.2 {
//            return true
//        }
//        
//        return false
//    }
//}
//
//
//
//
//extension UIColor {
//    var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
//        var hue: CGFloat = 0
//        var saturation: CGFloat = 0
//        var brightness: CGFloat = 0
//        var alpha: CGFloat = 0
//        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//        
//        let lightness = (2 - saturation) * brightness / 2
//        let saturationL = (lightness == 0 || lightness == 1) ? 0 : (brightness - lightness) / min(lightness, 1 - lightness)
//        
//        return (hue: hue, saturation: saturationL, lightness: lightness, alpha: alpha)
//    }
//    
//    convenience init(hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)) {
//        let (hue, saturationL, lightness, alpha) = hsl
//        let brightness: CGFloat
//        
//        if lightness < 0.5 {
//            brightness = lightness * (1 + saturationL)
//        } else {
//            brightness = lightness + saturationL - lightness * saturationL
//        }
//        
//        let saturation = (brightness == 0) ? 0 : 2 * (1 - lightness / brightness)
//        
//        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
//    }
//}



extension UIImage {
    func getMainColors() -> (UIColor, UIColor)? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let averageFilter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = averageFilter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext()
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        let averageColor = UIColor(red: CGFloat(bitmap[0]) / 255.0,
                                   green: CGFloat(bitmap[1]) / 255.0,
                                   blue: CGFloat(bitmap[2]) / 255.0,
                                   alpha: CGFloat(bitmap[3]) / 255.0)
        
        let complementaryColor = averageColor.complementaryColor()
        
        return (averageColor, complementaryColor)
    }
}

extension UIColor {
    func complementaryColor() -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let complementaryRed = 1.0 - red
        let complementaryGreen = 1.0 - green
        let complementaryBlue = 1.0 - blue
        
        return UIColor(red: complementaryRed, green: complementaryGreen, blue: complementaryBlue, alpha: alpha)
    }
}



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
    func getMainColors() -> (UIColor, UIColor)? {
        guard let resizedImage = self.resized(to: CGSize(width: 100, height: 100)) else { return nil }
        guard let inputImage = CIImage(image: resizedImage) else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(inputImage, from: inputImage.extent) else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapData = calloc(height * width * bytesPerPixel, MemoryLayout<UInt8>.size)
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        let bitmapContext = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        bitmapContext?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = bitmapContext?.data?.assumingMemoryBound(to: UInt8.self) else { return nil }
        
        var colorCounts: [UIColor: Int] = [:]
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let r = CGFloat(pixelData[pixelIndex]) / 255.0
                let g = CGFloat(pixelData[pixelIndex + 1]) / 255.0
                let b = CGFloat(pixelData[pixelIndex + 2]) / 255.0
                let a = CGFloat(pixelData[pixelIndex + 3]) / 255.0
                
                let color = UIColor(red: r, green: g, blue: b, alpha: a)
                colorCounts[color, default: 0] += 1
            }
        }
        
        free(bitmapData)
        
        let sortedColors = colorCounts.sorted { $0.value > $1.value }
        guard sortedColors.count > 1 else { return nil }
        
        let primaryColor = sortedColors[0].key
        var secondaryColor = sortedColors[1].key
        
        for color in sortedColors.dropFirst(1).map({ $0.key }) {
            if primaryColor.contrastsEnough(with: color) {
                secondaryColor = color
                break
            }
        }
        
        return (primaryColor, secondaryColor)
    }
}

extension UIColor {
    func contrastsEnough(with color: UIColor) -> Bool {
        let contrastRatio = (self.luminance() + 0.05) / (color.luminance() + 0.05)
        return contrastRatio > 1.5 || contrastRatio < 0.67
    }
    
    func luminance() -> CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        func component(_ c: CGFloat) -> CGFloat {
            return (c <= 0.03928) ? (c / 12.92) : pow((c + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * component(r) + 0.7152 * component(g) + 0.0722 * component(b)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



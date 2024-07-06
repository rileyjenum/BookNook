//
//  Utils.swift
//  BookNook
//
//  Created by Riley Jenum on 06/07/24.
//

import Foundation
import SDWebImageSwiftUI
import UIKit
import SwiftUI

import SwiftUI
import SDWebImage

struct Utils {
    func extractColors(for book: Book, index: Int, viewModel: BookViewModel, completion: @escaping (Color, Color) -> Void) {
        guard let coverImageUrl = book.coverImageUrl, let url = URL(string: coverImageUrl) else {
            completion(.beige, .black)
            return
        }
        
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            if let image = image {
                if let colors = image.getMainColors() {
                    let spineColor = Color(colors.0)
                    let textColor = Color(colors.1)
                    viewModel.colorCache[book.id] = (spineColor, textColor)
                    print("spineColor: \(spineColor)")
                    completion(spineColor, textColor)
                } else {
                    print("failed to extract colors")
                    completion(.beige, .black)
                }
            } else {
                print("failed to load image")
                completion(.beige, .black)
            }
        }
    }
}

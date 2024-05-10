//
//  TabbedItems.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case books
    case calendar
    case settings
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .books:
            return "Books"
        case .calendar:
            return "Calendar"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .books:
            return "book.closed"
        case .calendar:
            return "calendar"
        case .settings:
            return "gear"
        }
    }
}

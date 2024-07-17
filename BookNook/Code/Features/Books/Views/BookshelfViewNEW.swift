//
//  TEST.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI
import SwiftData

struct BookshelfViewNEW: View {
    
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = DiscoverScreenViewModel()

    @State private var draggedColor: Color?
    @State private var colors: [Color] = [.purple, .blue, .cyan, .green, .yellow, .orange, .red, .brown, .black, .pink, .gray]
    @State private var selectedColor: Color?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(alignment: .bottom, spacing: 2) {
                    ForEach(colors, id: \.self) { color in
                        BookViewAnimated(bookColor: color, selectedColor: $selectedColor)
                            .id(color)
                            .onDrag {
                                self.draggedColor = color
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text],
                                    delegate: DropViewDelegate(destinationItem: color, colors: $colors, draggedItem: $draggedColor)
                            )
                            .zIndex((draggedColor == color) || (selectedColor == color) ? 1 : 0)
                    }
                }
                .frame(height: 600)
                .onChange(of: selectedColor) {
                    if let color = selectedColor {
                        withAnimation {
                            proxy.scrollTo(color, anchor: .center)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BookshelfViewNEW()
}

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: Color
    @Binding var colors: [Color]
    @Binding var draggedItem: Color?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        if let draggedItem {
            let fromIndex = colors.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = colors.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.colors.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}

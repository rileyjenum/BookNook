//
//  MainTabbedScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

import Foundation

import SwiftUI

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .tag(0)

                BooksListScreen()
                    .tag(1)

                HomeScreen()
                    .tag(2)

                HomeScreen()
                    .tag(3)
            }
            
            ZStack{
                HStack(alignment: .top, spacing:0) {
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = 0
                        }
                    } label: {
                        VStack(alignment: .center, spacing:0) {
                            Image(systemName: "house")
                                .font(.system(size: 22, weight: .regular))
                                .frame(width: 44, height: 44)
                            Text("Home")
                                .font(.caption)
                                .lineSpacing(0.75)
                        }
                        .foregroundColor(Color(hex: selectedTab == 0 ? "c98510" : "FFF"))
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = 1
                        }
                    } label: {
                        VStack(alignment: .center, spacing:0) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 22, weight: .regular))
                                .frame(width: 44, height: 44)
                            Text("Books")
                                .font(.caption)
                                .lineSpacing(0.75)
                        }
                        .foregroundColor(Color(hex: selectedTab == 1 ? "c98510" : "FFF"))
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = 2
                        }
                    } label: {
                        VStack(alignment: .center, spacing:0) {
                            Image(systemName: "calendar")
                                .font(.system(size: 22, weight: .regular))
                                .frame(width: 44, height: 44)
                            Text("History")
                                .font(.caption)
                                .lineSpacing(0.75)
                        }
                        .foregroundColor(Color(hex: selectedTab == 2 ? "c98510" : "FFF"))
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = 3
                        }
                    } label: {
                        VStack(alignment: .center, spacing:0) {
                            Image(systemName: "gear")
                                .font(.system(size: 22, weight: .regular))
                                .frame(width: 44, height: 44)
                            Text("Settings")
                                .font(.caption)
                                .lineSpacing(0.75)
                        }
                        .foregroundColor(Color(hex: selectedTab == 3 ? "c98510" : "FFF"))
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                }
                .padding([.horizontal, .bottom], 10)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.65, blue: 1).opacity(0.25), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.2).opacity(0.1), location: 1.2),
                        ],
                        center: UnitPoint(x: 10.18, y: 0.54)
                    )
                )
                .overlay(
                    GeometryReader { proxy in
                        HStack {
                            if selectedTab == 1 {
                                Spacer()
                            }
                            if selectedTab == 2 {
                                Spacer()
                                Spacer()
                            }
                            if selectedTab == 3 {
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            ZStack {
                                Circle().offset(y: 30).fill(Color(hex: "c98510"))
                                    .blur(radius: 30)
                                Circle().offset(y: 64).fill(Color(hex: "c98510"))
                                    .blur(radius: 5)
                                Circle().offset(y: 65).fill(Color(hex: "c98510"))
                                    .blur(radius: 1)
                            }
                            .frame(width: proxy.size.width / 4)
                            .offset(y: 5)
                            if selectedTab == 0 {
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            if selectedTab == 1 {
                                Spacer()
                                Spacer()
                            }
                            if selectedTab == 2 {
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(colors: [.white.opacity(0.2), .white.opacity(0)], startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 1, lineJoin: .round))
                )
                .preferredColorScheme(.dark)

            }
            .padding(.horizontal, 26)
        }
        
        
    }
}


//#Preview {
//    MainTabbedView()
//
//}

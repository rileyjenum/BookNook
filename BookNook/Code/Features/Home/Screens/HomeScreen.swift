//
//  HomeScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 10/05/24.
//

//import SwiftUI
//import SplineRuntime
//import SwiftData
//
//struct HomeScreen: View {
//    
//    @EnvironmentObject var timerManager: TimerManager
//    
//    @State var showingBottomSheet = false
//
//    var body: some View {
//        VStack {
//            TopTitleView()
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(itemsData.items) { item in
//                        ZStack {
//                            if let url = URL(string: item.url) {
//                                try? SplineView(sceneFileURL: url)
//                                    .ignoresSafeArea(.all)
//                                    .scrollTransition { content, phase in
//                                        content
//                                            .scaleEffect(phase.isIdentity ? 1.4 : 0.75)
//                                    }
//                            }
//                        }
//                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                        .scrollTransition { content, phase in
//                            content
//                                .opacity(phase.isIdentity ? 1 : 0.1)
//                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
//                        }
//                    }
//                }
//                .frame(height: 400)
//                .scrollTargetLayout()
//            }
//            .contentMargins(64, for: .scrollContent)
//            .scrollTargetBehavior(.viewAligned)
//
//            if timerManager.isActive {
//                Text("Elapsed Time: \(Int(timerManager.elapsedTime)) seconds")
//                    .font(.headline)
//                    .padding()
//                Button("Stop Session") {
//                    timerManager.requestStopTimer()
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.bottom, 30)
//                .alert(isPresented: $timerManager.showStopAlert) {
//                    Alert(title: Text("Are you sure?"),
//                          message: Text("Do you want to stop the current reading session?"),
//                          primaryButton: .destructive(Text("Stop")) {
//                        timerManager.stopTimer()
//                    },
//                          secondaryButton: .cancel())
//                }
//            } else {
//                Button("Start Reading Session") {
//                    showingBottomSheet = true
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.bottom, 30)
//                .sheet(isPresented: $showingBottomSheet) {
//                    CreateSessionView()
//                        .environmentObject(timerManager)
//                }
//            }
//        }
//        .padding(.horizontal, 16)
//        .onDisappear {
//            if timerManager.isActive {
//                timerManager.stopTimer()
//            }
//        }
//    }
//}
//
//struct Item: Identifiable {
//    let id = UUID()
//    let url: String
//}
//
//struct itemsData {
//    static var items = [
//        Item(url: "https://build.spline.design/UU0-Uxi0XX7oJ1jNz-b7/scene.splineswift"),
//        Item(url: "https://build.spline.design/VBbgq2x2SjCnmhZeL8q3/scene.splineswift")
//    ]
//}
//
//struct HomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreen()
//            .environmentObject(TimerManager())
//
//    }
//}

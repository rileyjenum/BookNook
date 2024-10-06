//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 24/09/24.
//

import SwiftUI

struct HomeView2: View {
    @Namespace var namespace
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Top")
                Button {
                    withAnimation() {
                        showDetail.toggle()
                    }
                } label: {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                        .matchedGeometryEffect(id: "testId", in: namespace)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Text("Bottom")
            }
            .navigationDestination(isPresented: $showDetail) {
                DetailView(namespace: namespace)
            }
        }
    }
}

private struct DetailView: View {
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                .matchedGeometryEffect(id: "testId", in: namespace)
                .frame(width: 100, height: 100, alignment: .center)

            Text("Details")
            Spacer()
        }
    }
}
struct MatchedGeometryNavigationExample_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}

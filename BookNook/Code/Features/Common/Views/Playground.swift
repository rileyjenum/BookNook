//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {

    @State private var isProfileExpanded = false
    @Namespace private var profileAnimation
    @Namespace private var profileName
    @Namespace private var profileAvatar
    @Namespace private var profileJob
    
    var body: some View {
        VStack {
            if isProfileExpanded {
                expandedProfileView
            } else {
                collapsedProfileView
            }
            videoList
        }
    }

    var collapsedProfileView: some View {
        HStack {
            profileImage
                .matchedGeometryEffect(id: profileAvatar, in: profileAnimation)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text("Profile Name")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: profileName, in: profileAnimation)

                Text("iOS Developer")
                    .foregroundColor(.secondary)
                    .matchedGeometryEffect(id: profileJob, in: profileAnimation)
            }

            Spacer()
        }
        .padding()
    }

    var expandedProfileView: some View {
        VStack {
            profileImage
                .matchedGeometryEffect(id: profileAvatar, in: profileAnimation)
                .frame(width: 130, height: 130)

            VStack {
                Text("Profile Name")
                    .font(.title).bold()
                    .matchedGeometryEffect(id: profileName, in: profileAnimation)

                Text("iOS Developer")
                    .foregroundColor(.pink)
                    .matchedGeometryEffect(id: profileJob, in: profileAnimation)

                Text("Check this Cool description, Check this Cool description, Check this Cool description.")
                    .padding()
            }
        }
        .padding()
    }

    var profileImage: some View {
        Image(.homeTabIcon)
            .resizable()
            .clipShape(Circle())
            .onTapGesture {
                withAnimation(.spring()) {
                    isProfileExpanded.toggle()
                }
            }
    }

    var videoList: some View {
        List {
            ForEach(0...5, id: \.self) { _ in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 180)
                        .foregroundColor(.gray.opacity(0.2))

                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .opacity(0.3)
                }
                .padding(.vertical)

            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct Playground_previews: PreviewProvider {
    static var previews: some View {
        Playground().preferredColorScheme(.light)
    }
}

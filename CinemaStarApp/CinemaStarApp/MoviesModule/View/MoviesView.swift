// MoviesView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// dfgdf
struct MoviesView: View {
    var items = Array(1 ... 20)

    var body: some View {
        VStack {
            HStack {
                Text("Сморти исторические \nфильмы на ")
                    .font(.system(size: 20))
                    + Text("CINEMA STAR")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }.padding()
            Spacer()
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(0 ..< 20) { _ in
                        createCell(item: Movie(dto: DocDto(name: "Zima", poster: PosterDto(url: ""), rating: RatingDto(kp: 7.3), id: 21)))
                    }
                }
            }.padding([.leading, .trailing], 8)
        }
    }

    private func createCell(item: Movie) -> some View {
        VStack(alignment: .leading) {
            Image("tests")
                .resizable()
                .frame(width: 170, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(item.name)
            Text("\(item.rating)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}

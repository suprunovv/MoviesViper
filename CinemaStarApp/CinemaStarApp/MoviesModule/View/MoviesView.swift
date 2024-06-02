// MoviesView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Вью с фильмами
struct MoviesView: View {
    @StateObject var presenter: MoviesViewPresenter

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Сморти исторические \nфильмы на ")
                        .font(.system(size: 20))
                        + Text("CINEMA STAR")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }.padding()
                Spacer()
                switch presenter.state {
                case .sucsess:
                    moviesBody
                case .failure(let error):
                    Text(error.localizedDescription)
                default:
                    loadingBody
                }
            }
        }
    }
    
    private var loadingBody: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(0..<6) { _ in
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 170, height: 200)
                            .shimmer()
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 170, height: 40)
                            .shimmer()
                    }
                }
            }
        }
    }
    
    private var moviesBody: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]) {
                ForEach(presenter.movies, id: \.id) { movie in
                    createCell(item: movie)
                        .onTapGesture {
                            presenter.goToDetails(id: Int(movie.id) ?? 0)
                        }
                }
            }
        }.padding([.leading, .trailing])
    }
    
    private var background: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 179 / 255, green: 141 / 255, blue: 87 / 255, opacity: 0.51),
                Color(red: 43 / 255, green: 81 / 255, blue: 74 / 255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func createCell(item: Movie) -> some View {
        VStack(alignment: .leading) {
            Image(uiImage: UIImage(data: item.imageData ?? Data()) ?? UIImage())
                .resizable()
                .frame(width: 170, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(item.name)
                .foregroundColor(.white)
            Text("⭐" + String(format: "%.2f", item.rating))
                .foregroundColor(.white)
        }.frame(height: 250)
    }
}

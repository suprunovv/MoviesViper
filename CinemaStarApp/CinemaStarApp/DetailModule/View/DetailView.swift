// DetailView.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import SwiftUI

struct DetailView: View {
    
    @StateObject var presenter: DetailViewPresenter
    @State private var isShowText = false
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            VStack {
                topBody
                ScrollView(showsIndicators: false) {
                    switch presenter.state {
                    case .sucsess:
                        posterBody
                        descriptionBody
                        actorsBody
                        languageBody
                        recommendationBody
                    default:
                        posterBodyShimmer
                        descriptionBodyShimmer
                        actrosBodyShimmer
                        languageBodyShimmer
                    }
                }
            }
        }
    }

    private var topBody: some View {
        HStack {
            Button {
                presenter.goBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                presenter.likeToggle()
            } label: {
                Image(systemName: presenter.isLike ? "heart.fill" : "heart")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
        }.padding()
    }

    private var posterBody: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage(data: presenter.details?.imageData ?? Data()) ?? UIImage())
                    .resizable()
                    .frame(width: 170, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Spacer().frame(width: 16)
                VStack(alignment: .leading, spacing: 5) {
                    Text(presenter.details?.name ?? "")
                        .frame(width: 150,alignment: .leading)
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                    Text("\(presenter.details?.rating ?? 0)")
                        .foregroundColor(.white)
                }
                Spacer()
            }.padding([.leading, .trailing])
            Button {
                print("dfhdf")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 48)
                        .foregroundColor(Color(red: 43 / 255, green: 81 / 255, blue: 74 / 255))
                    Text("Смотреть")
                        .foregroundColor(.white)
                }
            }.padding([.leading, .trailing])
        }
    }
    
    private var posterBodyShimmer: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 170, height: 200)
                    .shimmer()
                Spacer().frame(width: 16)
                VStack(alignment: .leading, spacing: 5) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 150, height: 30)
                        .shimmer()
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 20)
                        .shimmer()
                }
                Spacer()
            }.padding([.leading, .trailing])
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 48)
                .padding([.leading, .trailing])
                .shimmer()
        }
    }
    
    private var descriptionBody: some View {
        HStack(alignment: .bottom) {
            Text(presenter.details?.deskription ?? "")
                .lineLimit(isShowText ? nil : 5)
                .foregroundColor(.white)
            Button {
                withAnimation(Animation.easeInOut) {
                    isShowText.toggle()
                }
            } label: {
                Image(systemName: isShowText ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white)
            }
        }.padding()
    }
    
    private var descriptionBodyShimmer: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 100)
            .shimmer()
            .padding()
    }
    
    private var actorsBody: some View {
        VStack(alignment: .leading) {
            Text("\(presenter.details?.year ?? 0) / \(presenter.details?.country ?? "") / \(presenter.details?.type ?? "")")
                .padding([.leading, .trailing])
            Spacer().frame(height: 18)
            Text("Актеры и съемочная группа")
                .padding([.leading, .trailing])
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(presenter.details?.actors ?? [], id: \.name) { actorr in
                        VStack(spacing: 2) {
                            Image(uiImage: UIImage(data: actorr.imageData ?? Data()) ?? UIImage())
                                .resizable()
                                .frame(width: 46, height: 73)
                            Text("\(actorr.name)")
                                .lineLimit(2)
                                .frame(width: 55, height: 24)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .font(.system(size: 8))
                        }
                    }
                }.padding([.leading, .trailing])
            }
        }
    }
    
    private var actrosBodyShimmer: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 150, height: 30)
                .padding([.leading, .trailing])
                .shimmer()
            Spacer().frame(height: 18)
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 150, height: 30)
                .padding([.leading, .trailing])
                .foregroundColor(.white)
                .shimmer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<8) { _ in
                        VStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 46, height: 73)
                                .shimmer()
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 55, height: 24)
                                .foregroundColor(.white)
                                .shimmer()
                        }
                    }
                }.padding([.leading, .trailing])
            }
        }
    }
    
    private var languageBody: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Язык")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(presenter.details?.language ?? "")
                    .font(.system(size: 14, weight: .light))
            }
            Spacer()
        }.padding([.leading, .trailing])
    }
    
    private var languageBodyShimmer: some View {
        HStack {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 80, height: 30)
                    .shimmer()
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 80, height: 30)
                    .shimmer()
            }
            Spacer()
        }.padding([.leading, .trailing])
    }
    
    private var recommendationBody: some View {
        VStack(alignment: .leading) {
            Text("Смотрите также")
                .padding([.leading, .trailing])
                .font(.system(size: 14, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(presenter.details?.semilarMovies ?? [], id: \.name) { movie in
                        VStack(alignment: .leading, spacing: 2) {
                            Image(uiImage: UIImage(data: movie.imageData ?? Data()) ?? UIImage())
                                .resizable()
                                .frame(width: 170, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("\(movie.name)")
                                .frame(width: 170, height: 40, alignment: .leading)
                                .font(.system(size: 16))
                                .lineLimit(2)
                                .foregroundColor(.white)
                        }
                    }
                }.padding([.leading, .trailing])
            }
        }
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
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}

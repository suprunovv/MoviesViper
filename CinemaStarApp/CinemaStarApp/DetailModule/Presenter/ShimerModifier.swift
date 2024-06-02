
import Foundation
import SwiftUI

struct ShimmerView: ViewModifier {
    @State private var isAnimating = false
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                        .opacity(isAnimating ? 1 : 0)
                        .onAppear {
                            withAnimation(Animation.linear.repeatForever()) {
                                isAnimating = true
                            }
                        }
                )
        }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerView())
    }
}

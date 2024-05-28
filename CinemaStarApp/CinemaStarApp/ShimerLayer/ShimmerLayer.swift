// ShimmerLayer.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Слой с анимированным шимером
final class ShimmerLayer: CAGradientLayer {
    // MARK: - Private property

    private let clearCollor: UIColor

    // MARK: - Initializators

    init(clearCollor: UIColor) {
        self.clearCollor = clearCollor
        super.init()
        setLayer()
        startAnimate()
    }

    required init?(coder: NSCoder) {
        clearCollor = .clear
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func setLayer() {
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 1)
        colors = [
            UIColor.shimerStartColor.cgColor,
            UIColor.shimerEndColor.cgColor,
            UIColor.shimerStartColor.cgColor
        ]
        locations = [-2, -1, 0, 1]
    }

    private func startAnimate() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-2, -1, 0, 1]
        animation.toValue = [0, 1, 2, 3]
        animation.repeatCount = .infinity
        animation.duration = 1.5
        add(animation, forKey: animation.keyPath)
    }
}

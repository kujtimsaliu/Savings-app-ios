//
//  CustomPieChartView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 28.8.24.
//

import UIKit

class CustomPieChartView: UIView {
    private var slices: [Slice] = []
    
    struct Slice {
        let value: Double
        let color: UIColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSlices(_ newSlices: [Slice]) {
        slices = newSlices
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let total = slices.reduce(0) { $0 + $1.value }
        
        var startAngle = -CGFloat.pi / 2
        
        for slice in slices {
            let endAngle = startAngle + CGFloat(2 * .pi * (slice.value / total))
            
            context.setFillColor(slice.color.cgColor)
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.closePath()
            context.fillPath()
            
            startAngle = endAngle
        }
    }
}



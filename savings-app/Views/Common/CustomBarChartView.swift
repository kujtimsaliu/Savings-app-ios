//
//  CustomBarChartView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 28.8.24.
//

import UIKit

class CustomBarChartView: UIView {
    private var bars: [Bar] = []
    let barWidth: CGFloat = 30
    let spacing: CGFloat = 20
    private let bottomPadding: CGFloat = 30 
    
    struct Bar {
        let value: Double
        let date: Date
        let color: UIColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBars(_ newBars: [Bar]) {
        bars = newBars
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let maxValue = bars.map { $0.value }.max() ?? 0
        let scale = (bounds.height - bottomPadding) / CGFloat(maxValue)
        
        for (index, bar) in bars.enumerated() {
            let barHeight = CGFloat(bar.value) * scale
            let x = CGFloat(index) * (barWidth + spacing)
            let y = bounds.height - barHeight - bottomPadding
            
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            
            // Draw gradient
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = barRect
            gradientLayer.colors = [bar.color.withAlphaComponent(0.7).cgColor, bar.color.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            
            // Render gradient to an image
            let gradientImage = UIGraphicsImageRenderer(size: barRect.size).image { ctx in
                gradientLayer.render(in: ctx.cgContext)
            }
            
            // Draw the gradient image into the context
            context.draw(gradientImage.cgImage!, in: barRect)
            
            // Draw shadow
            context.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.2).cgColor)
            context.setFillColor(UIColor.clear.cgColor)
            let shadowPath = UIBezierPath(roundedRect: barRect, cornerRadius: 8)
            context.addPath(shadowPath.cgPath)
            context.fillPath()
            
            // Draw date label
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let dateString = dateFormatter.string(from: bar.date)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                .foregroundColor: UIColor.label
            ]
            let attributedDate = NSAttributedString(string: dateString, attributes: attributes)
            let dateSize = attributedDate.size()
            let datePoint = CGPoint(x: x + (barWidth - dateSize.width) / 2, y: bounds.height - bottomPadding + 5)
            attributedDate.draw(at: datePoint)
        }
        
        // Draw X and Y axes
        drawAxis(in: context, rect: rect)
    }
    
    private func drawAxis(in context: CGContext, rect: CGRect) {
        context.setStrokeColor(UIColor.gray.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(1.0)
        
        // X-axis
        context.move(to: CGPoint(x: 0, y: rect.height - bottomPadding))
        context.addLine(to: CGPoint(x: rect.width, y: rect.height - bottomPadding))
        
        // Y-axis
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: rect.height - bottomPadding))
        
        context.strokePath()
    }
}

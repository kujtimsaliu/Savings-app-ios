//
//  CustomBarChartView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 28.8.24.
//

import UIKit

class CustomBarChartView: UIView {
    private var bars: [Bar] = []
    private let barWidth: CGFloat = 30
    private let spacing: CGFloat = 20
    private let bottomPadding: CGFloat = 30 // Space for dates
    
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
            
            context.setFillColor(bar.color.cgColor)
            context.fill(barRect)
            
            // Draw date label
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let dateString = dateFormatter.string(from: bar.date)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.label
            ]
            let attributedDate = NSAttributedString(string: dateString, attributes: attributes)
            let dateSize = attributedDate.size()
            let datePoint = CGPoint(x: x + (barWidth - dateSize.width) / 2, y: bounds.height - bottomPadding + 5)
            attributedDate.draw(at: datePoint)
        }
    }
}

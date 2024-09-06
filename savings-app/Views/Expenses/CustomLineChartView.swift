//
//  CustomLineChartView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 30.8.24.
//

import UIKit

class CustomLineChartView: UIView {
    private var dataPoints: [CGPoint] = []
    private let lineColor: UIColor = .systemBlue
    private let lineWidth: CGFloat = 2.0
    private let circleRadius: CGFloat = 6.0
    private let axisColor: UIColor = .systemGray4
    private let gridColor: UIColor = .systemGray6
    private let gridLineWidth: CGFloat = 0.5

    func setDataPoints(_ points: [CGPoint]) {
        self.dataPoints = points
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw grid lines
        drawGridLines(in: rect, context: context)
        
        // Draw axes
        drawAxes(in: rect, context: context)
        
        guard !dataPoints.isEmpty else { return }
        
        // Scale points to fit the view
        let scaledPoints = scalePoints(dataPoints, to: rect.size)
        
        // Draw line
        drawLine(with: scaledPoints, in: context)
        
        // Draw circles at data points
        drawCircles(at: scaledPoints, in: context)
    }
    
    private func drawGridLines(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(gridLineWidth)
        
        let numberOfLines = 5
        let spacing = rect.height / CGFloat(numberOfLines)
        
        for i in 1..<numberOfLines {
            let y = CGFloat(i) * spacing
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        context.strokePath()
    }
    
    private func drawAxes(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(1.0)
        
        // X-axis
//        context.move(to: CGPoint(x: 0, y: rect.height - 20))
//        context.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
//        
//        // Y-axis
//        context.move(to: CGPoint(x: 20, y: 0))
//        context.addLine(to: CGPoint(x: 20, y: rect.height))
        
        context.strokePath()
    }
    
    private func drawLine(with points: [CGPoint], in context: CGContext) {
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(lineWidth)
        
        context.move(to: points[0])
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
    
    private func drawCircles(at points: [CGPoint], in context: CGContext) {
        context.setFillColor(lineColor.cgColor)
        
        for point in points {
            context.fillEllipse(in: CGRect(x: point.x - circleRadius, y: point.y - circleRadius,
                                           width: circleRadius * 2, height: circleRadius * 2))
        }
    }
    
    private func scalePoints(_ points: [CGPoint], to size: CGSize) -> [CGPoint] {
        guard !points.isEmpty else { return [] }
        
        let minX = points.map { $0.x }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 0
        let minY = points.map { $0.y }.min() ?? 0
        let maxY = points.map { $0.y }.max() ?? 0
        
        let xRange = maxX - minX
        let yRange = maxY - minY
        
        return points.map { point in
            let x = (point.x - minX) / xRange * (size.width - 40) + 20
            let y = size.height - ((point.y - minY) / yRange * (size.height - 40) + 20)
            return CGPoint(x: x, y: y)
        }
    }
}

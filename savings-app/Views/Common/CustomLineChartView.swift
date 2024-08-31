//
//  CustomLineChartView.swift
//  savings-app
//
//  Created by Kujtim Saliu on 30.8.24.
//

import UIKit

class CustomLineChartView: UIView {
    private var dataPoints: [CGPoint] = []
    private let lineGradientColors: [UIColor] = [.systemBlue, .systemTeal]
    private let circleRadius: CGFloat = 8.0
    private let axisColor: UIColor = .systemGray
    private let gridColor: UIColor = .systemGray6
    private let gridLineWidth: CGFloat = 0.8
    private let axisLabelFont: UIFont = .systemFont(ofSize: 12)
    private let xAxisLabelHeight: CGFloat = 20
    private let yAxisLabelWidth: CGFloat = 40
    
    private let tooltipView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tooltipView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataPoints(_ points: [(date: Date, amount: Double)]) {
        self.dataPoints = points.map { CGPoint(x: $0.date.timeIntervalSince1970, y: $0.amount) }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawGridLines(in: rect, context: context)
        drawAxes(in: rect, context: context)
        guard !dataPoints.isEmpty else { return }
        
        let scaledPoints = scalePoints(dataPoints, to: rect.size)
        drawGradientLine(with: scaledPoints, in: context)
        
        drawCircles(at: scaledPoints, in: context)
    }
    
    private func drawGridLines(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(gridLineWidth)
        
        let numberOfLines = 6
        let spacing = rect.height / CGFloat(numberOfLines)
        
        for i in 1..<numberOfLines {
            let y = CGFloat(i) * spacing
            context.move(to: CGPoint(x: yAxisLabelWidth, y: y))
            context.addLine(to: CGPoint(x: rect.width - 20, y: y))
        }
        
        context.strokePath()
    }
    
    private func drawAxes(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(1.0)
        
        context.move(to: CGPoint(x: yAxisLabelWidth, y: rect.height - xAxisLabelHeight))
        context.addLine(to: CGPoint(x: rect.width - 20, y: rect.height - xAxisLabelHeight))
        
        context.move(to: CGPoint(x: yAxisLabelWidth, y: rect.height - xAxisLabelHeight))
        context.addLine(to: CGPoint(x: yAxisLabelWidth, y: xAxisLabelHeight))
        
        context.strokePath()
        
        drawAxisLabels(in: rect)
    }
    
    private func drawAxisLabels(in rect: CGRect) {
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: axisLabelFont,
            .foregroundColor: axisColor
        ]
        
        let yValues = stride(from: 0, to: maxAmount(), by: maxAmount() / 5)
        for value in yValues {
            let labelText = String(format: "%.0f", value)
            let label = UILabel(frame: CGRect(x: 0, y: rect.height - xAxisLabelHeight - (value / maxAmount() * (rect.height - xAxisLabelHeight * 2)),
                                              width: yAxisLabelWidth, height: xAxisLabelHeight))
            label.text = labelText
            label.font = axisLabelFont
            label.textColor = axisColor
            label.textAlignment = .right
            label.sizeToFit()
            addSubview(label)
        }
        
        // Draw X-axis labels
        let xValues = stride(from: 0, to: rect.width - yAxisLabelWidth, by: (rect.width - yAxisLabelWidth - 20) / CGFloat(dataPoints.count - 1))
        for (index, value) in xValues.enumerated() {
            if index < dataPoints.count {
                let date = Date(timeIntervalSince1970: dataPoints[index].x)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                let labelText = dateFormatter.string(from: date)
                let label = UILabel(frame: CGRect(x: value, y: rect.height - xAxisLabelHeight,
                                                  width: yAxisLabelWidth, height: xAxisLabelHeight))
                label.text = labelText
                label.font = axisLabelFont
                label.textColor = axisColor
                label.textAlignment = .center
                label.sizeToFit()
                addSubview(label)
            }
        }
    }
    
    private func drawGradientLine(with points: [CGPoint], in context: CGContext) {
        let gradient = CAGradientLayer()
        gradient.colors = lineGradientColors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = bounds
        
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        context.saveGState()
        context.addPath(path.cgPath)
        context.replacePathWithStrokedPath()
        context.clip()
        gradient.render(in: context)
        context.restoreGState()
        
        path.stroke()
    }
    
    private func drawCircles(at points: [CGPoint], in context: CGContext) {
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.setStrokeColor(lineGradientColors.last?.cgColor ?? UIColor.clear.cgColor)
        context.setLineWidth(2.0)
        
        for point in points {
            let circlePath = UIBezierPath(ovalIn: CGRect(x: point.x - circleRadius, y: point.y - circleRadius,
                                                         width: circleRadius * 1.5, height: circleRadius * 1.5))
            context.addPath(circlePath.cgPath)
            context.fillPath()
            context.strokePath()
        }
    }
    
    private func scalePoints(_ points: [CGPoint], to size: CGSize) -> [CGPoint] {
        guard !points.isEmpty else { return [] }
        
        let minX = points.map { $0.x }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 0
        let minY = points.map { $0.y }.min() ?? 0
        let maxY = points.map { $0.y }.max() ?? 0
        
        return points.map { point in
            let x = (point.x - minX) / (maxX - minX) * (size.width - yAxisLabelWidth - 20) + yAxisLabelWidth
            let y = size.height - xAxisLabelHeight - ((point.y - minY) / (maxY - minY) * (size.height - xAxisLabelHeight - 20))
            return CGPoint(x: x, y: y)
        }
    }
    
    private func maxAmount() -> CGFloat {
        guard let maxY = dataPoints.map({ $0.y }).max() else { return 0 }
        return ceil(maxY / 100) * 100
    }
    
    private func showTooltip(at point: CGPoint, withText text: String) {
        tooltipView.text = text
        tooltipView.sizeToFit()
        tooltipView.frame.size.width += 10
        tooltipView.frame.size.height += 6
        tooltipView.center = point
        tooltipView.isHidden = false
    }
    
    private func hideTooltip() {
        tooltipView.isHidden = true
    }
}

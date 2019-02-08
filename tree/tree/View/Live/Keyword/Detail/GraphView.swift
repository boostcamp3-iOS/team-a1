//
//  GraphView.swift
//  tree
//
//  Created by ParkSungJoon on 06/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    private let dataLayer: CALayer = CALayer()
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    private let gridLayer: CALayer = CALayer()
    private var dataPoints: [CGPoint]?
    
    private let contentSpace: CGFloat = 60
    private let bottomSpace: CGFloat = 30
    private let leftSpace: CGFloat = 30
    
    var graphData: KeywordResult? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        mainLayer.addSublayer(dataLayer)
        scrollView.layer.addSublayer(mainLayer)
        self.layer.addSublayer(gridLayer)
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        guard let graphData = graphData else { return }
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.size.width,
            height: self.frame.size.height
        )
        scrollView.contentSize = CGSize(
            width: CGFloat(graphData.data.count) * contentSpace + 100,
            height: self.frame.size.height
        )
        mainLayer.frame = CGRect(
            x: 0, y: 0, width: CGFloat(graphData.data.count) * contentSpace,
            height: self.frame.size.height
        )
        dataLayer.frame = CGRect(
            x: leftSpace,
            y: 0,
            width: mainLayer.frame.width,
            height: mainLayer.frame.height - bottomSpace
        )
        gridLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: mainLayer.frame.height - bottomSpace
        )
        dataPoints = points(from: graphData)
        scrollView.showsHorizontalScrollIndicator = false
        removeAllLayer()
        drawHorizontalLines()
        drawGraph()
        drawBottomLabels()
    }
    
    private func points(from graphData: KeywordResult) -> [CGPoint] {
        var result: [CGPoint] = []
        for index in 0..<graphData.data.count {
            let graphValue = CGFloat(graphData.data[index].ratio)
            let multipier = 1 - (graphValue / 100)
            let height = dataLayer.frame.height * multipier
            let point = CGPoint(
                x: CGFloat(index) * contentSpace,
                y: height
            )
            result.append(point)
        }
        return result
    }
    
    private func drawGraph() {
        guard
            let dataPoints = dataPoints,
            let path = createPath(),
            dataPoints.count > 0 else {
                return
        }
        let lineLayer = drawLineLayer(
            path: path,
            lineWidth: 3.0,
            lineColor: UIColor.brightBlue.cgColor
        )
        dataLayer.addSublayer(lineLayer)
    }
    
    private func createPath() -> UIBezierPath? {
        guard
            let dataPoints = dataPoints,
            dataPoints.count > 0 else {
                return nil
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        
        for index in 1..<dataPoints.count {
            path.addLine(to: dataPoints[index])
        }
        return path
    }
    
    private func drawBottomLabels() {
        guard
            let graphData = graphData,
            graphData.data.count > 0 else {
                return
        }
        for index in 0..<graphData.data.count {
            let textLayer = drawTextLayer(alignmentMode: .left, fontSize: 11)
            textLayer.frame = CGRect(
                x: contentSpace * CGFloat(index) + leftSpace / 2,
                y: mainLayer.frame.size.height - bottomSpace / 2,
                width: 100,
                height: 16
            )
            let date = graphData.data[index].period.components(separatedBy: "-")
            textLayer.string = date[1] + "." + date[2]
            mainLayer.addSublayer(textLayer)
        }
    }
    
    private func drawHorizontalLines() {
        let gridValues: [CGFloat] = [0, 0.25, 0.5, 0.75, 1]
        for index in 0..<gridValues.count {
            let height = gridValues[index] * gridLayer.frame.size.height
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: leftSpace, y: height))
            path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))
            
            let lineLayer = drawLineLayer(
                path: path,
                lineWidth: 0.5,
                lineColor: UIColor.whiteGray.cgColor
            )

            if gridValues[index] > 0.0 && gridValues[index] < 1.0 {
                lineLayer.lineDashPattern = [4, 4]
            }
            gridLayer.addSublayer(lineLayer)
            
            let textLayer = drawTextLayer(alignmentMode: .right, fontSize: 12)
            textLayer.frame = CGRect(
                x: 0,
                y: height - 7,
                width: 20,
                height: 16
            )
            let reverseIndexValue = gridValues[gridValues.count - 1 - index]
            textLayer.string = "\(Int(reverseIndexValue * 100))"
            gridLayer.addSublayer(textLayer)
        }
    }
    
    private func removeAllLayer() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
    private func drawTextLayer(
        alignmentMode: CATextLayerAlignmentMode,
        fontSize: CGFloat
    ) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.whiteGray.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = CATextLayerAlignmentMode(rawValue: alignmentMode.rawValue)
        textLayer.fontSize = fontSize
        return textLayer
    }
    
    private func drawLineLayer(
        path: UIBezierPath,
        lineWidth: CGFloat,
        lineColor: CGColor
    ) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor
        lineLayer.lineWidth = lineWidth
        return lineLayer
    }
}

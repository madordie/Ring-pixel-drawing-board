//
//  DrawingBoard.swift
//  Demo-Transform
//
//  Created by 孙继刚 on 2017/6/22.
//  Copyright © 2017年 madordie. All rights reserved.
//

import UIKit

class DrawingBoard: UIView {
    fileprivate var currentLayer: CALayer?
    fileprivate var allItems: [Item] = []
    fileprivate var unionRects: [CGRect] = []
    fileprivate let unionCount = 5

    func setup() {
        allItems.removeAll()

        /// 圈数
        let section = 4
        /// 每圈个数
        let row = 30
        /// 每个弧度
        let rowRadian = CGFloat(2 * Double.pi / Double(row))
        /// 跳过的半径
        let skipR = 50
        /// 步长
        let step = 40
        let width = self.frame.width
        let height = self.frame.height
        for section in 0..<section {
            for row in 0..<row {
                let layer = Layer()
                layer.borderWidth = 0.5
                layer.strokeColor = UIColor.red.cgColor
                layer.fillColor = UIColor.white.cgColor
                layer.frame = CGRect(x: 0, y: 0, width: width, height: height)

                let bezierPath = UIBezierPath()
                bezierPath.addArc(withCenter: center,
                                  radius: CGFloat(skipR + step * section),
                                  startAngle: rowRadian * CGFloat(row),
                                  endAngle: rowRadian * CGFloat(row + 1),
                                  clockwise: true)
                bezierPath.addArc(withCenter: center,
                                  radius: CGFloat(skipR + step * section + step),
                                  startAngle: rowRadian * CGFloat(row + 1),
                                  endAngle: rowRadian * CGFloat(row),
                                  clockwise: false)
                bezierPath.close()
                layer.bezierPath = bezierPath
                self.layer.addSublayer(layer)
                allItems.append(Item(layer))
            }
        }

        unionRects.removeAll()
        var idx = 0
        while idx < allItems.count {
            var unionRect = allItems[idx].rect
            let end = min(idx + unionCount, allItems.count)

            for i in idx+1..<end {
                unionRect = CGRect.union(unionRect)(allItems[i].rect)
            }
            idx = end
            self.unionRects.append(unionRect)
        }
    }
}

extension DrawingBoard {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hitPoint(touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        hitPoint(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLayer = nil
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLayer = nil
    }

    func hitPoint(_ touches: Set<UITouch>) {
        guard allItems.count > 0 else { return }
        guard let point = touches.first?.location(in: self) else { return }
        var layer: Layer?
        for idx in 0..<unionRects.count {
            guard unionRects[idx].contains(point) else { continue }
            for i in (idx*unionCount)..<min((idx+1)*unionCount, allItems.count) {
                let item = allItems[i]
                guard item.bezierPath.contains(point) else { continue }
                layer = item.layer
                break
            }
            guard layer != nil else { continue }
            break
        }
        guard let tapLayer = layer else { return }
        guard tapLayer != currentLayer else { return }
        tapLayer.isSelected = !tapLayer.isSelected
        currentLayer = tapLayer
    }
}

extension DrawingBoard {
    struct Item {
        let layer: Layer
        let bezierPath: UIBezierPath
        let rect: CGRect
        init(_ layer: Layer) {
            self.layer = layer
            self.bezierPath = layer.bezierPath ?? UIBezierPath()
            self.rect = layer.bezierPath?.bounds ?? CGRect.zero
        }
    }
}

class Layer: CAShapeLayer {
    var bezierPath: UIBezierPath? {
        didSet {
            guard let bezierPath = bezierPath else { return }
            path = bezierPath.cgPath
        }
    }
    var isSelected: Bool = false {
        didSet {
            guard isSelected != oldValue else { return }
            if isSelected {
                fillColor = UIColor.brown.cgColor
            } else {
                fillColor = UIColor.white.cgColor
            }
        }
    }
}

//
//  CircleProgressBarView.swift
//  simpleCircleProgresBar
//
//  Created by  Matvey on 11.01.2021.
//

import UIKit

class CircleProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    var lineWidth: CGFloat
    
    init(lineWidth: CGFloat = 0, frame: CGRect) {
        self.lineWidth = lineWidth
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                        radius: frame.width / 2 - lineWidth / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = AppColor.progressBarTrack?.cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.blue.cgColor
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval, progress: Int) {
        let delay = 0.3
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut) {
            self.createAnimation(duration: duration, progress: progress, delay: delay)
        }

    }
    
    private func createAnimation(duration: TimeInterval, progress: Int, delay: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")

        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = max(0.01, min(Double(progress) / 100, 1.0))
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.beginTime = CACurrentMediaTime() + delay
        
        let colorChangeAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        colorChangeAnimation.values = colorSet(progress: progress) as [Any]
        colorChangeAnimation.fillMode = .forwards
        colorChangeAnimation.isRemovedOnCompletion = false
        colorChangeAnimation.duration = duration
        
        progressLayer.add(colorChangeAnimation, forKey: "colorChangeAnimation")
        progressLayer.add(circularProgressAnimation, forKey: "progressAnimation")
    }
    
    private func colorSet(progress: Int) -> [CGColor?] {
        var colorSet = [AppColor.boxState20Up?.cgColor]
        switch progress {
        case 11...25:
            colorSet = [AppColor.boxState20Up?.cgColor,
                        AppColor.boxState40Up?.cgColor]
        case 25...50:
            colorSet = [AppColor.boxState20Up?.cgColor,
                        AppColor.boxState40Up?.cgColor,
                        AppColor.boxState60Up?.cgColor]
        case 51...75:
            colorSet = [AppColor.boxState20Up?.cgColor,
                        AppColor.boxState40Up?.cgColor,
                        AppColor.boxState60Up?.cgColor,
                        AppColor.boxState80Up?.cgColor]
        case 76...100:
            colorSet = [AppColor.boxState20Up?.cgColor,
                        AppColor.boxState40Up?.cgColor,
                        AppColor.boxState60Up?.cgColor,
                        AppColor.boxState80Up?.cgColor,
                        AppColor.boxState100Up?.cgColor]
        default:
            break
        }
        return colorSet
    }
}



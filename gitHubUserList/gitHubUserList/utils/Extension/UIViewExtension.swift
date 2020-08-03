//
//  UIView+Extension.swift
//  ImitationOfTodayNews
//
//  Created by DU on 2017/5/24.
//  Copyright © 2017年 DU. All rights reserved.
//

import Foundation
import UIKit

enum OscillatoryAnimationType {
    case bigger
    case smaller
}

extension UIView{
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var size : CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
    
    func getAbsolutePosition()->CGPoint{
        var point=self.frame.origin
        
        if let parent = self.superview{
            let parentPoint=parent.getAbsolutePosition()
            point = CGPoint(x:point.x+parentPoint.x,y:point.y+parentPoint.y)
        }
        return point
    }
    
    func drawDashLine(pointA : CGPoint ,pointB : CGPoint,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
//        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor

        shapeLayer.lineWidth = self.frame.size.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        shapeLayer.lineDashPattern = [NSNumber(value: 2),NSNumber(value: 2)]

        let path = CGMutablePath()
        path.move(to: pointA)
        path.addLine(to: pointB)

        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}

//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by wry on 2018/8/18.
//  Copyright © 2018年 wry. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //stroke but not fill
//        if let context = UIGraphicsGetCurrentContext()
//        {
//            //draw a circle
//            context.addArc(center: CGPoint(x:bounds.midX, y: bounds.midY),
//                           radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
        
        
        //stroke and fill
        //but if rotate, it will not be a circle anymore
        //to fix this, change "main story board" view -> content mode to "redraw"
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x:bounds.midX, y: bounds.midY),
                       radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        path.fill()
        
    }
 

}

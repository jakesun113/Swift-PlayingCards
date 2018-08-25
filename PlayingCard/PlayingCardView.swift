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
        //make the corner of the screen round
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
 

}

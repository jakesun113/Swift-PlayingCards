//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by wry on 2018/8/18.
//  Copyright © 2018年 wry. All rights reserved.
//

import UIKit

//use this label to show the actual effect on the main story board view
@IBDesignable

class PlayingCardView: UIView {

    //sub views needs layout
    //use IBInspectable tag to see all the var you want to see in the storyboard
    @IBInspectable
    var rank: Int = 12 { didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var suit: String = "♥" { didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isFaceup: Bool = true { didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    //make the number of the card in the center and size is scalable
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString
    {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        //scale font so that the size can be scaled accordingly
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString
    {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel
    {
        let label = UILabel()
        //initialize as "0": can has lines as many as you want
        label.numberOfLines = 0
        //add self into sub view
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel)
    {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        //hide the element if is not faced up
        label.isHidden = !isFaceup
    }
    
    //make the font size of the app change according to the iphone setting
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    //UIview as super, do auto layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        //draw the upper left card
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        //draw the lower right card, using double offset
        configureCornerLabel(lowerRightCornerLabel)
        //move the number and the suit upside down
        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height).rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY).offsetBy(dx: -cornerOffset, dy: -cornerOffset).offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
    
    //draw pips number
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        //embedded func, func in a func
        func createPipsString(thatFits pipRect:CGRect) -> NSAttributedString
        {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0){max($1.count,$0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0){max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkPipString = centeredAttributedString(suit, fontSize: probablyOkPipStringFontSize)
            if probablyOkPipString.size().width > pipRect.size.width / maxHorizontalPipCount
            {
                return centeredAttributedString(suit, fontSize: probablyOkPipStringFontSize / (probablyOkPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            }
            else
            {
                return probablyOkPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank)
        {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipsString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow
            {
                switch pipCount
                {
                case 1: pipString.draw(in: pipRect)
                case 2: pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default: break
                }
                
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //make the corner of the screen round
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceup
        {
            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
            else
            {
                drawPips()
            }
        }
        else
        {
            if let cardBackImage = UIImage(named: "cardback",in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
}

// rewrite the initialized value
extension PlayingCardView
{
    private struct SizeRatio
    {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat
    {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String
    {
        switch rank
        {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect
{
    var leftHalf: CGRect
    {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect
    {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func insert(by size: CGSize) -> CGRect
    {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect
    {
        return CGRect(origin: origin, size: size)
    }
    func zoom (by scale: CGFloat) -> CGRect
    {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}

extension CGPoint
{
    func offsetBy(dx: CGFloat, dy:CGFloat) -> CGPoint
    {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

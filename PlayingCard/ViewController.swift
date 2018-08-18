//
//  ViewController.swift
//  PlayingCard
//
//  Created by wry on 2018/8/18.
//  Copyright © 2018年 wry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for _ in 1...10
        {
            if let card = deck.draw()
            {
                print("\(card)")
            }
        }
    
    }



}


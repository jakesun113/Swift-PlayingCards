//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by wry on 2018/8/18.
//  Copyright © 2018年 wry. All rights reserved.
//

import Foundation

//add protocol: CustomStringConvertible
struct PlayingCard: CustomStringConvertible
{
    var description: String {return "\(rank)\(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    //raw value of enum type
    enum Suit: String
    {
        var description: String {return ""}
        
        case spades = "♠"
        case hearts = "♥"
        case diamonds = "♦"
        case clubs = "♣"
        
        static var all = [Suit.spades, Suit.hearts, Suit.diamonds, Suit.clubs]
    }
    
    enum Rank
    {
        
        case ace
        //associated data
        //J, Q, or K
        case face(String)
        //other number
        case numeric(Int)
        
        var order: Int
        {
            switch self {
            case .ace:
                return 1
            case .numeric(let pips): return pips
            //pattern matching: "where"
            case .face(let kind) where kind == "J": return 11
                case .face(let kind) where kind == "Q": return 12
                case .face(let kind) where kind == "K": return 13
            default:
                return 0
            }
        }
        
        static var all: [Rank]
        {
            var allRank: [Rank] = [.ace]
            //from 2 to 10 (including 10)
            for pips in 2...10
            {
                allRank.append(Rank.numeric(pips))
            }
            allRank += [Rank.face("J"),Rank.face("Q"),Rank.face("K")]
            return allRank
        }
    }
    
}

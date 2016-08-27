//
//  LewisClassicalCardLayout.swift
//  LewisWorkout
//
//  Created by brendan kerr on 7/6/16.
//  Copyright © 2016 b3k3r. All rights reserved.
//

import Foundation
import UIKit

protocol ClassicCardLayout {
    mutating func layoutShapes(Model model: LWCard, InsideRect rect: CGRect)
}

struct ClassicalCardLayout<Shape: Shapeable>: ClassicCardLayout {
    
    var rectSection: CGSize!
    var originShiftX: CGFloat!
    var originShiftY: CGFloat!
    var offsets: [CGFloat]!
    var content: ShapeQueue<Shape>
    let doubleSeperation: CGFloat = 35
    var baseHeight: CGFloat!
    //var sideways: Bool = false
    
    
    init(WithContents content: ShapeQueue<Shape>) {
        self.content = content
    }
    
    //MARK: Layout protocol
    
    mutating func layoutShapes(Model model: LWCard, InsideRect rect: CGRect) {
        //Layout using contents directed by model
        
        //self.sideways = side
        rectSection = rectSections(model, WithRect: rect.size)
        offsets = placementPointOffsets(model)
        originShiftX = rect.origin.x
        originShiftY = rect.origin.y
        baseHeight = rectBaseHeight(FromHeight: rect.height)
        
        switch model.rank.rowsForRank {
            
        case 6:
            row6(model)
            fallthrough
        case 5:
            row5(model)
            fallthrough
        case 4:
            row4(model)
            fallthrough
        case 3:
            row3(model)
            fallthrough
        case 2:
            row2(model)
            fallthrough
        case 1:
            row1(model)
            break
            
        default:
            print("default")
        }
    }
    
    
    private mutating func row1(model: LWCard) {
        
        switch model.rank {
        case .Ace, .Two, .Three:
            single(widthForRow(1), Height: heightForRow(1))
            break
        case .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten:
            double(widthForRow(1), Height: heightForRow(1))
            break
        default:
            break
            
        }
        
    }
    
    private mutating func row2(model: LWCard) {
        
        switch model.rank {
        case .Two, .Three, .Five, .Seven, .Eight, .Ten:
            single(widthForRow(2), Height: heightForRow(2))
            break
        case .Four, .Six, .Nine:
            double(widthForRow(2), Height: heightForRow(2))
            break
        default:
            break
            
        }

    }
    
    private mutating func row3(model: LWCard) {
        
        switch model.rank {
        case .Three, .Nine:
            single(widthForRow(3), Height: heightForRow(3))
            break
        case .Five, .Six, .Seven, .Eight, .Ten:
            double(widthForRow(3), Height: heightForRow(3))
            break
        default:
            break
            
        }

    }
    
    private mutating func row4(model: LWCard) {
        
        switch model.rank {
        case .Eight:
            single(widthForRow(4), Height: heightForRow(4))
            break
        case .Seven, .Nine, .Ten:
            double(widthForRow(4), Height: heightForRow(4))
            break
        default:
            break
            
        }

    }
    
    private mutating func row5(model: LWCard) {
        
        switch model.rank {
        case .Ten:
            single(widthForRow(5), Height: heightForRow(5))
            break
        case .Eight, .Nine:
            double(widthForRow(5), Height: heightForRow(5))
            break
        default:
            break
            
        }

    }
    
    private mutating func row6(model: LWCard) {
        
        switch model.rank {
        case .Ten:
            double(widthForRow(6), Height: heightForRow(6))
            break
        default:
            break
            
        }

    }
    
    
    
    private func heightForRow(row: Int) -> CGFloat {
        return rectSection.height * offsets[row - 1] + baseHeight //+ originShiftY
    }
    
    private func widthForRow(row: Int) -> CGFloat {
        return rectSection.width //+ originShiftX
    }
    
    
    private mutating func double(atWidth: CGFloat, Height atHeight: CGFloat) {
        horizontalDouble(atWidth, Height: atHeight)
    }
    
    
    private mutating func horizontalDouble(atWidth: CGFloat, Height atHeight: CGFloat) {
        
        let leftShape = content.dequeue()
        let rightShape = content.dequeue()
        
        leftShape?.place(AtPoint: CGPointMake(atWidth - doubleSeperation, atHeight))
        rightShape?.place(AtPoint: CGPointMake(atWidth + doubleSeperation, atHeight))
        
    }
    
    private mutating func verticalDouble(atWidth: CGFloat, Height atHeight: CGFloat) {
        
        let leftShape = content.dequeue()
        let rightShape = content.dequeue()
        
        //rotate 90 deg before place
        leftShape?.rotateBy(CGFloat(M_PI_2))
        rightShape?.rotateBy(CGFloat(M_PI_2))
        
        leftShape?.place(AtPoint: CGPointMake(atWidth, atHeight - doubleSeperation))
        rightShape?.place(AtPoint: CGPointMake(atWidth, atHeight + doubleSeperation))
        
    }

    private mutating func single(atWidth: CGFloat, Height atHeight: CGFloat) {
        
        let singleShape = content.dequeue()
        singleShape?.place(AtPoint: CGPointMake(atWidth, atHeight))
    }
    
    
    
    //MARK: Utilities for where to place each shape
    
    private func placementPointOffsets(model: LWCard) -> [CGFloat] {
        
        switch model.rank.rowsForRank {
        case 1:
            return [3]
        case 2:
            return [1, 5]
        case 3:
            return [1, 3, 5]
        case 4:
            return [1, 2, 3, 5]
        case 5:
            return [1, 2, 3, 4, 5]
        case 6:
            return [1, 2, 3, 5, 6, 7]
        default:
            print("defualt")
            return []
        }
    }
    
    private func rectSections(model: LWCard, WithRect rectSize: CGSize) -> CGSize {
        
        if model.rank.rawValue < 10 {
            
            return CGSizeMake(rectSize.width / 2, rectSize.height / 8)
        } else if model.rank.rawValue == 10  {
            return CGSizeMake(rectSize.width/2, rectSize.height/8)
        } else {
            return CGSizeZero
        }
    }
    
    private func rectBaseHeight(FromHeight rectHeight: CGFloat) -> CGFloat {
        return rectHeight / 8
    }

    
    
}


//





//    mutating func layout(rect: CGRect) {
//        //Layout in given rect
//        self.rectSection = rectSections(rect.size)
//        self.offsets = placementPointOffsets()
//
//        switch cardModel.card.rank {
//        case .Ace:
//
//            empty(rectSection.width, Height:  heightForRow(1))
//            empty(rectSection.width, Height: heightForRow(2))
//            single(rectSection.width, Height: heightForRow(3))
//            empty(rectSection.width, Height: heightForRow(4))
//            empty(rectSection.width, Height: heightForRow(5))
//            empty(rectSection.width, Height: heightForRow(6))
//
//
//            break
//
//        case .Two:
//
////            newRowFormatter(FirstRow: single,
////                            SecondRow: empty,
////                            ThirdRow: empty,
////                            FourthRow: empty,
////                            FifthRow: single,
////                            SixthRow: empty)
//            break
//
//        case .Three:
//
////            newRowFormatter(FirstRow: single,
////                            SecondRow: empty,
////                            ThirdRow: single,
////                            FourthRow: empty,
////                            FifthRow: single,
////                            SixthRow: empty)
////
//            break
//
//        case .Four:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: empty,
////                            ThirdRow: empty,
////                            FourthRow: empty,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//
//        case .Five:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: empty,
////                            ThirdRow: single,
////                            FourthRow: empty,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//
//        case .Six:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: empty,
////                            ThirdRow: horizontalDouble,
////                            FourthRow: empty,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//
//        case .Seven:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: single,
////                            ThirdRow: horizontalDouble,
////                            FourthRow: empty,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//
//        case .Eight:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: single,
////                            ThirdRow: horizontalDouble,
////                            FourthRow: single,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//
//        case .Nine:
//
////            newRowFormatter(FirstRow: horizontalDouble,
////                            SecondRow: horizontalDouble,
////                            ThirdRow: single,
////                            FourthRow: horizontalDouble,
////                            FifthRow: horizontalDouble,
////                            SixthRow: empty)
//            break
//        default: break
//            //defualt
//        }
//
//
//    }
//
//
//    //MARK: Layout formatts
//
//    func newRowFormatter(FirstRow row1: (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer], SecondRow row2:
//        (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer], ThirdRow row3:
//        (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer], FourthRow row4:
//        (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer], FifthRow row5:
//        (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer], SixthRow row6:
//        (atWidth: CGFloat, atHeight: CGFloat) -> [CAShapeLayer]) {
//
//        var rowAccumulator: [CAShapeLayer] = Array()
//
//        let first = row1(atWidth: rectSection.width, atHeight: heightForRow(1))
//        rowAccumulator += first
//        let second = row2(atWidth: rectSection.width, atHeight: heightForRow(2))
//        rowAccumulator += second
//        let third = row3(atWidth: rectSection.width, atHeight: heightForRow(3))
//        rowAccumulator += third
//        let fourth = row4(atWidth: rectSection.width, atHeight: heightForRow(4))
//        rowAccumulator += fourth
//        let fifth = row5(atWidth: rectSection.width, atHeight: heightForRow(5))
//        rowAccumulator += fifth
//        let sixth = row6(atWidth: rectSection.width, atHeight: heightForRow(6))
//        rowAccumulator += sixth
//
//
//    }





//        self.rectSection = rectSections(rect.size)
//        self.offsets = placementPointOffsets()
//
//
//        if cardModel.card.rank == .Ace || cardModel.card.rank == .Ace || cardModel.card.rank == .Ace {
//            single(rectSection.width, Height: heightForRow(1))
//        }
//        if cardModel.card.rank == .Ace || cardModel.card.rank == .Ace || cardModel.card.rank == .Ace
//
//        switch cardModel.card.rank {
//
//
//
//        case .Ten:
//            single(rectSection.width, Height: heightForRow(5))
//        case .Seven, .Nine, .Ten:
//            horizontalDouble(rectSection.width, Height: heightForRow(4))
//        case .Eight:
//            single(rectSection.width, Height: heightForRow(4))
//        case .Five, .Six, .Seven, .Eight, .Ten:
//            horizontalDouble(rectSection.width, Height: heightForRow(3))
//        case .Three, .Nine:
//            single(rectSection.width, Height: heightForRow(3))
//        case .Four, .Six, .Nine:
//            horizontalDouble(rectSection.width, Height: heightForRow(2))
//        case .Two, .Three, .Five, .Seven, .Eight, .Ten:
//            single(rectSection.width, Height: heightForRow(2))
//        case .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten:
//            horizontalDouble(rectSection.width, Height: heightForRow(1))
//        case .Ace, .Two, .Three:
//
//
//
//
//
//
//        default:
//            print("hit default")
//            break
//
//
//        }
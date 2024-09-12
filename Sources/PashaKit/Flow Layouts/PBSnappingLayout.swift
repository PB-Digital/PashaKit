//
//  PBSnappingLayout.swift
//  
//
//  Created by Murad on 16.09.23.
//
//  
//  MIT License
//  
//  Copyright (c) 2022 Murad Abbasov
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy 
//  of this software and associated documentation files (the "Software"), to deal 
//  in the Software without restriction, including without limitation the rights 
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//  copies of the Software, and to permit persons to whom the Software is 
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
//  THE SOFTWARE.

//
//  HorizontalSnappingLayout.swift
//

import UIKit

public class PBSnappingLayout: UICollectionViewFlowLayout {

    public enum SnapPositionType: Int {
        case left
        case center
        case right
    }

    public var snapPosition = SnapPositionType.center

    private let minimumSnapVelocity: CGFloat = 0.3

    public override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        var offsetAdjusment = CGFloat.greatestFiniteMagnitude

        let horizontalPosition = switch snapPosition {
        case .left:
            proposedContentOffset.x + collectionView.contentInset.left + sectionInset.left
        case .center:
            proposedContentOffset.x + (collectionView.bounds.width * 0.5)
        case .right:
            proposedContentOffset.x + collectionView.bounds.width - sectionInset.right
        }

        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.size.width,
            height: collectionView.bounds.size.height
        )

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach { layoutAttributes in
            let itemHorizontalPosition = switch snapPosition {
            case .left:
                layoutAttributes.frame.minX
            case .center:
                layoutAttributes.center.x
            case .right:
                layoutAttributes.frame.maxX
            }

            if abs(itemHorizontalPosition - horizontalPosition) < abs(offsetAdjusment) {
                if abs(velocity.x) < self.minimumSnapVelocity {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition
                } else if velocity.x > 0 {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition + (layoutAttributes.bounds.width + minimumLineSpacing)
                } else {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition - (layoutAttributes.bounds.width + minimumLineSpacing)
                }
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
}

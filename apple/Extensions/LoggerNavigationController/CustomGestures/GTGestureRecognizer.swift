//
//  GTGestureRecognizer.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/24/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

enum SymbolPhase {
    case notStarted
    case initialPoint
    case rightDownStroke
    case leftDownStroke
}

public class GTGestureRecognizer: UIGestureRecognizer {
    var strokePhase: SymbolPhase = .notStarted
    var initialTouchPoint: CGPoint = CGPoint.zero
    var trackedTouch: UITouch?

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if touches.count != 1 {
            state = .failed
        }
        // Capture the first touch and store some information about it.
        if trackedTouch == nil {
            trackedTouch = touches.first
            strokePhase = .initialPoint
            initialTouchPoint = (trackedTouch?.location(in: view))!
        } else {
            // Ignore all but the first touch.
            for touch in touches {
                if touch != trackedTouch {
                    ignore(touch, for: event)
                }
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let newTouch = touches.first
        // There should be only the first touch.
        guard newTouch == trackedTouch else {
            state = .failed
            return
        }
        let newPoint = (newTouch?.location(in: view))!
        let previousPoint = (newTouch?.previousLocation(in: view))!

        if strokePhase == .initialPoint {
            // Make sure the initial movement is down and to the right.
            if newPoint.x >= initialTouchPoint.x && newPoint.y >= initialTouchPoint.y {
                strokePhase = .rightDownStroke
            } else {
                state = .failed
            }
        } else if strokePhase == .rightDownStroke {
            // Make sure the initial movement is down and to the left.
            if newPoint.y >= previousPoint.y {
                if newPoint.x <= previousPoint.x {
                    strokePhase = .leftDownStroke
                }
            } else {
                state = .failed
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let newTouch = touches.first
        // There should be only the first touch.
        guard newTouch == trackedTouch else {
            state = .failed
            return
        }
        let newPoint = (newTouch?.location(in: view))!
        // If the stroke was down up and the final point is
        // below the initial point, the gesture succeeds.
        if state == .possible &&
            strokePhase == .leftDownStroke &&
            newPoint.y > initialTouchPoint.y {
            state = .recognized
        } else {
            state = .failed
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
        reset()
    }

    public override func reset() {
        super.reset()
        initialTouchPoint = CGPoint.zero
        strokePhase = .notStarted
        trackedTouch = nil
    }
}

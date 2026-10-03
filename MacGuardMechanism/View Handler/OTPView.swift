//
//  OTPView.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

import Cocoa

class OTPView: NSStackView, NSTextFieldDelegate {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

class Solution {
    func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
        guard nums.count > 3 else {
            return nums.reduce(0, +)
        }
        var sum: Int?
        let newList = nums.sorted()
        for i in 0...nums.count - 3 {
            var initialPointer = i + 1
            var finalPointer = nums.count - 1
            while initialPointer < finalPointer {
                let newSum = newList[i] + newList[initialPointer] + newList[finalPointer]
                let newDiff = abs(newSum - target)
                if sum == nil {
                    sum = newSum
                } else {
                    let existingDiff = abs(sum! - target)
                    if existingDiff > newDiff {
                        sum = newSum
                    }
                }
                
                if newSum > target {
                        finalPointer -= 1
                    } else if newSum < target {
                        initialPointer += 1
                    } else {
                        return newSum
                    }
            }
        }
        return sum ?? 0
    }
}

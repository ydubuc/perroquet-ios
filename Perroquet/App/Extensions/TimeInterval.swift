//
//  TimeInterval.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import Foundation

extension TimeInterval {
    var seconds: Int {
        return Int(self.rounded())
    }

    var milliseconds: Int {
        return Int(self * 1000)
    }
}

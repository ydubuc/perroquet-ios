//
//  String.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/28/24.
//

import Foundation
import SwiftUI

extension String {
    func attributed(highlight: String) -> AttributedString {
        var attributedString = AttributedString(self)

        if let range = attributedString.range(of: highlight) {
            attributedString[range].foregroundColor = .yellow
        }

        return attributedString
    }
}

extension Binding<String> {
    func attributed(highlight: String) -> AttributedString {
        return self.wrappedValue.attributed(highlight: highlight)
    }
}

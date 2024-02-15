//
//  FormTextfieldComponentExtension.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when isVisible: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {

        ZStack(alignment: alignment) {

            placeholder().opacity(isVisible ? 1 : 0)

            self

        } // ZStack

    }
}

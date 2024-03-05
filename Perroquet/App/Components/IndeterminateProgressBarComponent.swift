//
//  IndeterminateProgressBarComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import SwiftUI

struct IndeterminateProgressBarComponent: View {
    static private let height: CGFloat = 4
    static private let indicatorWidth: CGFloat = 100
    @State private var offset: CGFloat = -indicatorWidth

    var body: some View {

        ZStack(alignment: .leading) {

            GeometryReader { geo in

                Rectangle()
                    .foregroundColor(Color(UIColor.systemTeal))
                    .frame(
                        width: geo.size.width,
                        height: IndeterminateProgressBarComponent.height
                    )
                    .opacity(0.2)

                Rectangle()
                    .zIndex(1)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .frame(
                        width: IndeterminateProgressBarComponent.indicatorWidth,
                        height: IndeterminateProgressBarComponent.height
                    )
                    .offset(x: offset)
                    .animation(.default.repeatForever(autoreverses: true), value: offset)
                    .onAppear {
                        offset = geo.size.width
                    }

            } // GeometryReader
            .frame(height: IndeterminateProgressBarComponent.height)

        } // ZStack
        .frame(height: IndeterminateProgressBarComponent.height)

    }
}

extension View {
    func progressBar(isLoading: Bool) -> some View {

        ZStack(alignment: .top) {

            self

            if isLoading {
                IndeterminateProgressBarComponent()
                    .zIndex(1)
            }

        } // ZStack
    }
}

#Preview {
    IndeterminateProgressBarComponent()
}

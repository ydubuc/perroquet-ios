//
//  IndeterminateProgressBarComponentExt.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import Foundation

import SwiftUI

extension View {
    func progressBar(isPresented: Binding<Bool>) -> some View {
        
        ZStack(alignment: .top) {
            
            self

            if isPresented.wrappedValue {
                IndeterminateProgressBarComponent()
                    .zIndex(1)
            }
            
        } // ZStack
    }
}

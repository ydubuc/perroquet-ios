//
//  LazyView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/28/24.
//

import SwiftUI

struct LazyView<Content: View>: View {
    @Binding var loadWhen: Bool
    let content: () -> Content

    var body: some View {
        if loadWhen {
            content()
        } else {
            Color.clear
        }
    }
}

#Preview {
    LazyView(loadWhen: .constant(true)) {
        Text("Hello, World!")
    }
}

//
//  FormHeaderComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/14/24.
//

import SwiftUI

struct FormHeaderComponent: View {
    let image: ImageResource

    var body: some View {

        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)

    }
}

#Preview {
    FormHeaderComponent(image: .login)
}

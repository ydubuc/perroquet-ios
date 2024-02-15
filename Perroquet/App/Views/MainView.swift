//
//  MainView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appVm: AppViewModel
    
    var body: some View {
        Text("Main View")
            .onTapGesture {
                appVm.isLoggedIn = !appVm.isLoggedIn
            }
    }
}

#Preview {
    MainView()
}

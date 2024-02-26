//
//  DiscoverView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject var vm: DiscoverViewModel
    
    init(vm: StateObject<DiscoverViewModel> = .init(wrappedValue: .init(dto: .init(
        id: nil,
        userId: nil,
        search: nil,
        visibility: nil,
        sort: nil,
        cursor: nil,
        limit: nil
    )))) {
        _vm = vm
    }
    
    var body: some View {
        
        let currentTimeInMillis = Date().timeIntervalSince1970.milliseconds
        
        ScrollView(.vertical, showsIndicators: true) {
            
            LazyVStack(alignment: .leading, spacing: Dims.spacingRegular) {
                
                Text("Discover")
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                    ForEach(vm.reminders) { reminder in
                        ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                    }
                }
                .frame(maxWidth: Dims.viewMaxWidth1)
                .padding(Dims.spacingRegular)
                .background(vm.appVm.theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
                
                Button(action: {
                    AuthMan.shared.onSignout()
                }, label: {
                    Text("Sign out")
                })
                
            } // LazyVStack
            .padding(Dims.spacingRegular)

        } // ScrollView
        .refreshable {
            await vm.load()
        }
        
    }
}

#Preview {
    DiscoverView()
}

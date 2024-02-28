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
            
            LazyVStack(alignment: .center, spacing: Dims.spacingRegular) {
                
                Text("Discover")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if !vm.reminders.isEmpty {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.reminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                } else {
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {
                        
                        Text("Nothing here")
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                }
                
                Button(action: {
                    AuthMan.shared.onSignout()
                }, label: {
                    Text("Sign out")
                        .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
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

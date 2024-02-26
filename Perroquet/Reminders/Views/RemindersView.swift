//
//  RemindersView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct RemindersView: View {
    @StateObject var vm: RemindersViewModel
    
    init(vm: StateObject<RemindersViewModel> = .init(wrappedValue: .init(dto: .init(
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
            
            VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                
                let upcomingReminders = vm.reminders.filter { $0.triggerAt >= currentTimeInMillis }
                
                Text("Upcoming (\(upcomingReminders.count))")
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if upcomingReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(upcomingReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .frame(maxWidth: Dims.viewMaxWidth1)
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                } else {
                    HStack(alignment: .center, spacing: 0) {
                     
                        Text("All done here!")
                            .foregroundColor(vm.appVm.theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                        
                        Spacer()
                        
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                }
                
                let previousReminders = vm.reminders.filter { $0.triggerAt < currentTimeInMillis }
                
                Text("Previous (\(previousReminders.count))")
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if previousReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(previousReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .frame(maxWidth: Dims.viewMaxWidth1)
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                } else {
                    HStack(alignment: .center, spacing: 0) {
                     
                        Text("Nothing going on here! 🎉")
                            .foregroundColor(vm.appVm.theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                        
                        Spacer()
                        
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                }
                
            } // VStack
            .padding(Dims.spacingRegular)

        } // ScrollView
        .refreshable {
            await vm.load()
        }
        
    }
}

#Preview {
    RemindersView(
        vm: .init(wrappedValue: .init(dto: .init(
            id: nil,
            userId: nil,
            search: nil,
            visibility: nil,
            sort: nil,
            cursor: nil,
            limit: nil
        )))
    )
}

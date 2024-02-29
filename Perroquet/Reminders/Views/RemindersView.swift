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
            
            VStack(alignment: .center, spacing: Dims.spacingRegular) {
                
                Text("Today")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if vm.todayReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.todayReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
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
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                }
                
                Text("In next 7 days")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if vm.sevenDaysReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.sevenDaysReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                } else {
                    HStack(alignment: .center, spacing: 0) {
                     
                        Text("Smooth sailing ahead! 🦜")
                            .foregroundColor(vm.appVm.theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                        
                        Spacer()
                        
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                }
                
                Text("Later")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if vm.laterReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.laterReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                } else {
                    HStack(alignment: .center, spacing: 0) {
                     
                        Text("Nothing planned! 🎉")
                            .foregroundColor(vm.appVm.theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                        
                        Spacer()
                        
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                }
                
                Text("Previous")
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                    .foregroundColor(vm.appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                
                if vm.previousReminders.count > 0 {
                    VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                        ForEach(vm.previousReminders) { reminder in
                            ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                        }
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                } else {
                    HStack(alignment: .center, spacing: 0) {
                     
                        Text("Nothing going on here!")
                            .foregroundColor(vm.appVm.theme.fontDim)
                            .font(.body.weight(.regular))
                            .lineLimit(1)
                        
                        Spacer()
                        
                    }
                    .padding(Dims.spacingRegular)
                    .background(vm.appVm.theme.primaryDark)
                    .cornerRadius(Dims.cornerRadius)
                    .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
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
        vm: .init(wrappedValue: .init(
            reminders: [
                Reminder(
                    id: "1",
                    userId: "321",
                    title: nil,
                    body: "Hello, World! 1",
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "2",
                    userId: "321",
                    title: nil,
                    body: "Hello, World! 2",
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "3",
                    userId: "321",
                    title: nil,
                    body: "Hello, World! 3 This one goes over multiple lines to test whether or not it is aligned properly therefore it needs to be very long like this",
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "4",
                    userId: "321",
                    title: nil,
                    body: "Hello, World! 4",
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                )
            ],
            dto: .init(
                id: nil,
                userId: nil,
                search: nil,
                visibility: nil,
                sort: nil,
                cursor: nil,
                limit: nil
            )
        ))
    )
}

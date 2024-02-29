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
        
        ScrollView(.vertical, showsIndicators: true) {
            
            LazyVStack(alignment: .center, spacing: Dims.spacingRegular) {
                
                reminderSection(
                    title: "Today",
                    placeholder: "All done here! 🦜",
                    reminders: vm.todayReminders
                )
                
                reminderSection(
                    title: "In the next 7 days",
                    placeholder: "Smooth sailing ahead! ⛵️",
                    reminders: vm.sevenDaysReminders
                )
                
                reminderSection(
                    title: "Later",
                    placeholder: "Nothing planned! 🎉",
                    reminders: vm.laterReminders
                )
                
                reminderSection(
                    title: "Previous",
                    placeholder: "I can tell this is the beginning of an incredible friendship!",
                    reminders: vm.previousReminders
                )
                
            } // VStack
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .refreshable {
            await vm.load()
        }
        
    }
    
    func reminderSection(
        title: String,
        placeholder: String,
        reminders: [Reminder]
    ) -> some View {
        Group {
         
            Text(title)
                .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                .foregroundColor(vm.appVm.theme.fontNormal)
                .font(.body.weight(.bold))
                .lineLimit(2)
            
            if reminders.count > 0 {
                VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                    ForEach(reminders) { reminder in
                        ReminderComponent(reminder: reminder, theme: vm.appVm.theme)
                    }
                }
                .padding(Dims.spacingRegular)
                .background(vm.appVm.theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
                .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: 0) {
                 
                    Text(placeholder)
                        .foregroundColor(vm.appVm.theme.fontDim)
                        .font(.body.weight(.regular))
                    
                    Spacer()
                    
                }
                .padding(Dims.spacingRegular)
                .background(vm.appVm.theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
                .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
            }
            
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

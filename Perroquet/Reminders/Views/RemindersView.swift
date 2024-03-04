//
//  RemindersView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct RemindersView: View {
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: RemindersViewModel
    
    init(vm: StateObject<RemindersViewModel> = .init(wrappedValue: .init())) {
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
                    placeholder: "Well well well...",
                    reminders: vm.previousReminders
                )
                
            } // VStack
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .refreshable {
            await vm.load()
        }
        .sheet(isPresented: $appVm.isPresentingCreateReminderView) {
            CreateReminderView(vm: .init(wrappedValue: .init(listener: vm)))
                .environmentObject(appVm)
                .background(ClearBackgroundView())
        }
        .onOpenURL { url in
            if url.scheme == "widget" && url.host == "com.beamcove.perroquet.create-reminder" {
                appVm.isPresentingCreateReminderView = true
            }
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
                .foregroundColor(appVm.theme.fontNormal)
                .font(.body.weight(.bold))
                .lineLimit(2)
            
            if reminders.count > 0 {
                VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                    ForEach(reminders) { reminder in
                        ReminderComponent(reminder: reminder, listener: vm, theme: appVm.theme)
                    }
                }
                .padding(Dims.spacingRegular)
                .background(appVm.theme.primaryDark)
                .cornerRadius(Dims.cornerRadius)
                .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: 0) {
                 
                    Text(placeholder)
                        .foregroundColor(appVm.theme.fontDim)
                        .font(.body.weight(.regular))
                    
                    Spacer()
                    
                }
                .padding(Dims.spacingRegular)
                .background(appVm.theme.primaryDark)
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
                    title: "Hello, World! 1",
                    description: "This is a test",
                    tags: ["test", "one", "two"],
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "2",
                    userId: "321",
                    title: "Hello, World! 2",
                    description: "This is a test",
                    tags: ["test", "one", "two"],
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "3",
                    userId: "321",
                    title: "Hello, World! 3 This one goes over multiple lines to test whether or not it is aligned properly therefore it needs to be very long like this",
                    description: "This is a test that goes over multiple lines to test whether or not it is aligned properly therefore it needs to be very long like this",
                    tags: ["test", "one", "two"],
                    frequency: nil,
                    visibility: 0,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Reminder(
                    id: "4",
                    userId: "321",
                    title: "Hello, World! 4",
                    description: "This is a test",
                    tags: ["test", "one", "two"],
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
                tags: nil,
                visibility: nil,
                sort: nil,
                cursor: nil,
                limit: nil
            )
        ))
    )
}

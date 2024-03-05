//
//  ReminderComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct ReminderComponent: View {
    @EnvironmentObject private var appVm: AppViewModel

    let reminder: Reminder
    let listener: ReminderListener?

    @State private var isPresentingReminderView = false

    var body: some View {

        Button(action: {
            isPresentingReminderView = true
        }, label: {
            VStack(alignment: .leading, spacing: Dims.spacingSmallest) {

                Text(reminder.title)
                    .foregroundColor(appVm.theme.fontNormal)
                    .font(.body.weight(.regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)

                Text("\(Date(timeIntervalSince1970: TimeInterval(reminder.triggerAt) / 1000).formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(appVm.theme.fontBright)
                    .font(.caption.weight(.regular))
                    .lineLimit(1)

            }
        })
        .sheet(isPresented: $isPresentingReminderView) {
            ReminderView(vm: .init(wrappedValue: .init(reminder: reminder, listener: listener)))
                .environmentObject(appVm)
                .presentationDetents([.medium, .large])
        }

    }
}

#Preview {
    ReminderComponent(
        reminder: Reminder(
            id: "123",
            userId: "321",
            title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            tags: ["test", "one", "two"],
            frequency: nil,
            visibility: 0,
            triggerAt: 1708358620664,
            updatedAt: 1708358620664,
            createdAt: 1708358620664
        ),
        listener: nil
    )
    .environmentObject(AppViewModel())
}

//
//  MemoComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct MemoComponent: View {
    @EnvironmentObject private var appVm: AppViewModel

    let memo: Memo
    let listener: MemoListener?

    @State private var isPresentingMemoView = false

    var body: some View {

        Button(action: {
            isPresentingMemoView = true
        }, label: {
            VStack(alignment: .leading, spacing: Dims.spacingSmallest) {

                Text(memo.title)
                    .foregroundColor(appVm.theme.fontNormal)
                    .font(.body.weight(.regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)

                Text("\(Date(timeIntervalSince1970: TimeInterval(memo.triggerAt) / 1000).formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(appVm.theme.fontBright)
                    .font(.caption.weight(.regular))
                    .lineLimit(1)

            }
        })
        .sheet(isPresented: $isPresentingMemoView) {
            MemoView(vm: .init(wrappedValue: .init(memo: memo, listener: listener)))
                .environmentObject(appVm)
                .presentationDetents([.medium, .large])
        }

    }
}

#Preview {
    MemoComponent(
        memo: Memo(
            id: "123",
            userId: "321",
            title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            priority: "high",
            status: "pending",
            visibility: 0,
            frequency: "daily",
            triggerAt: 1708358620664,
            updatedAt: 1708358620664,
            createdAt: 1708358620664
        ),
        listener: nil
    )
    .environmentObject(AppViewModel())
}

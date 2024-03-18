//
//  MemosView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct MemosView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: MemosViewModel

    init(vm: StateObject<MemosViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true) {

            VStack(alignment: .center, spacing: Dims.spacingRegular) {

                memoSection(
                    title: "Today",
                    placeholder: "All done here! 🦜",
                    memos: vm.todayMemos
                )

                memoSection(
                    title: "In the next 7 days",
                    placeholder: "Smooth sailing ahead! ⛵️",
                    memos: vm.sevenDaysMemos
                )

                memoSection(
                    title: "Later",
                    placeholder: "Nothing planned! 🎉",
                    memos: vm.laterMemos
                )

                memoSection(
                    title: "Previous",
                    placeholder: "Well well well...",
                    memos: vm.previousMemos
                )

            } // VStack
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
        .sheet(isPresented: $appVm.isPresentingCreateMemoView) {
            CreateMemoView(vm: .init(wrappedValue: .init(listener: vm)))
                .environmentObject(appVm)
                .background(ClearBackgroundView())
        }
        .onOpenURL { url in
            if url.scheme == "widget" && url.host == "com.beamcove.perroquet.create-memo" {
                appVm.isPresentingCreateMemoView = true
            }
        }
        .refreshable {
            guard !vm.isLoading else { return }
            vm.isLoading = true
            Task { await vm.load() }
        }
        .onChange(of: scenePhase, perform: { value in
            switch value {
            case .active:
                guard !vm.isLoading else { return }
                vm.isLoading = true
                Task { await vm.load() }
            default:
                break
            }
        })

    }

    func memoSection(
        title: String,
        placeholder: String,
        memos: [Memo]
    ) -> some View {
        Group {

            Text(title)
                .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
                .foregroundColor(appVm.theme.fontNormal)
                .font(.body.weight(.bold))
                .lineLimit(2)

            if memos.count > 0 {
                VStack(alignment: .leading, spacing: Dims.spacingSmall) {
                    ForEach(memos) { memo in
                        MemoComponent(memo: memo, listener: vm)
                            .environmentObject(appVm)
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
    MemosView(
        vm: .init(wrappedValue: .init(
            memos: [
                Memo(
                    id: "1",
                    userId: "321",
                    title: "Hello, World! 1",
                    description: "This is a test",
                    priority: "high",
                    status: "pending",
                    visibility: 0,
                    frequency: nil,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Memo(
                    id: "2",
                    userId: "321",
                    title: "Hello, World! 2",
                    description: "This is a test",
                    priority: "medium",
                    status: "pending",
                    visibility: 0,
                    frequency: nil,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Memo(
                    id: "3",
                    userId: "321",
                    title: "Hello, World! 3 This one goes over multiple lines to test whether or not it is aligned properly therefore it needs to be very long like this",
                    description: "This is a test that goes over multiple lines to test whether or not it is aligned properly therefore it needs to be very long like this",
                    priority: "low",
                    status: "completed",
                    visibility: 0,
                    frequency: nil,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                ),
                Memo(
                    id: "4",
                    userId: "321",
                    title: "Hello, World! 4",
                    description: "This is a test",
                    priority: nil,
                    status: "completed",
                    visibility: 0,
                    frequency: nil,
                    triggerAt: 1709231354445,
                    updatedAt: 1709231354445,
                    createdAt: 1709231354445
                )
            ],
            dto: .init(
                id: nil,
                userId: nil,
                search: nil,
                priority: nil,
                status: nil,
                visibility: nil,
                sort: nil,
                cursor: nil,
                limit: nil
            )
        ))
    )
}

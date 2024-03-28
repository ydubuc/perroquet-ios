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

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    init(vm: StateObject<MemosViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }

    var body: some View {

        let content = ScrollView(.vertical, showsIndicators: true) {

            VStack(alignment: .center, spacing: Dims.spacingRegular) {

                memoSection(
                    title: "Today",
                    placeholder: "All done here! 🦜",
                    memos: vm.todayMemos,
                    isShowingSection: $vm.isShowingTodayMemos
                ) {
                    vm.toggleIsShowingTodayMemos()
                }

                memoSection(
                    title: "In the next 7 days",
                    placeholder: "Smooth sailing ahead! ⛵️",
                    memos: vm.sevenDaysMemos,
                    isShowingSection: $vm.isShowingSevenDaysMemos
                ) {
                    vm.toggleIsShowingSevenDaysMemos()
                }

                memoSection(
                    title: "Later",
                    placeholder: "Nothing planned! 🎉",
                    memos: vm.laterMemos,
                    isShowingSection: $vm.isShowingLaterMemos
                ) {
                    vm.toggleIsShowingLaterMemos()
                }

                memoSection(
                    title: "Completed",
                    placeholder: "I see you've been busy...",
                    memos: vm.completedMemos,
                    isShowingSection: $vm.isShowingCompletedMemos
                ) {
                    vm.toggleIsShowingCompleted()
                }

            } // VStack
            .frame(maxWidth: .infinity)
            .padding(Dims.spacingRegular)
            .padding(.bottom, 200)

        } // ScrollView
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

        if idiom == .pad {
            content
                .fullScreenCover(isPresented: $appVm.isPresentingCreateMemoView) {
                    CreateMemoView(vm: .init(wrappedValue: .init(listener: vm)))
                        .environmentObject(appVm)
                        .background(ClearBackgroundView())
                }
        } else {
            content
                .sheet(isPresented: $appVm.isPresentingCreateMemoView) {
                    CreateMemoView(vm: .init(wrappedValue: .init(listener: vm)))
                        .environmentObject(appVm)
                        .background(ClearBackgroundView())
                }
        }

    }

    func memoSection(
        title: String,
        placeholder: String,
        memos: [Memo],
        isShowingSection: Binding<Bool>,
        onTapTitle: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .foregroundColor(appVm.theme.fontNormal)
                    .font(.body.weight(.bold))
                    .lineLimit(2)

                Spacer()

                Image(systemName: isShowingSection.wrappedValue ? "chevron.up.circle" : "chevron.down.circle")
                    .foregroundColor(appVm.theme.fontDim)
                    .font(.body.weight(.bold))
            }
            .padding(Dims.spacingRegular)
            .background(isShowingSection.wrappedValue ? .clear : appVm.theme.primaryDark)
            .cornerRadius(Dims.cornerRadius)
            .frame(maxWidth: Dims.viewMaxWidth2, alignment: .leading)
            .onTapGesture {
                onTapTitle()
            }

            if isShowingSection.wrappedValue {
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
                    priority: 3,
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
                    priority: 2,
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
                    priority: 1,
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
                    priority: 0,
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
    .environmentObject(AppViewModel())
    .environment(\.scenePhase, .inactive)
}

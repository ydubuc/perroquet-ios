//
//  MemoView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import SwiftUI

struct MemoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: MemoViewModel

    @FocusState var isFocusingTextfield: Bool

    init(vm: StateObject<MemoViewModel>) {
        _vm = vm
    }

    var body: some View {

        GeometryReader { geometry in

            VStack(alignment: .center, spacing: 0) {

                VStack(alignment: .leading, spacing: Dims.spacingRegular) {

                    HStack(alignment: .center, spacing: Dims.spacingRegular) {

                        Spacer()

                        Menu {
                            Button(action: {
                                vm.deleteMemo()
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Label("Delete", systemImage: "trash.circle")
                            })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(appVm.theme.fontDim)
                                .font(.title2.weight(.bold))
                        }

                    } // HStack
                    .frame(maxWidth: Dims.formMaxWidth)

                    FormTextfieldMultilineComponent(
                        text: $vm.title,
                        title: .constant("Remind me to..."),
                        placeholder: $vm.placeholder,
                        theme: appVm.theme
                    )
                    .focused($isFocusingTextfield)
                    .frame(maxWidth: Dims.formMaxWidth)
                    .onChange(of: vm.title, perform: { _ in
                        DispatchQueue.main.async {
                            let dates = vm.title.findDates()
                            if let date = dates.last {
                                vm.triggerAtDate = date
                            }
                        }
                    })

                    HStack(alignment: .center, spacing: Dims.spacingRegular) {

                        Button(action: {
                            vm.isPresentingDatePickerView = true
                        }, label: {
                            Text("on \(vm.triggerAtDate.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundColor(appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        .sheet(isPresented: $vm.isPresentingDatePickerView) {
                            DatePickerView(date: $vm.triggerAtDate, theme: appVm.theme)
                                .background(ClearBackgroundView())
                        }

                        MemoFrequencyComponent(
                            frequency: $vm.frequency,
                            theme: appVm.theme
                        )

                        MemoPriorityComponent(
                            priority: $vm.priority,
                            theme: appVm.theme
                        )

                        Spacer()

                        Button(action: {
                            vm.editMemo()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                                .foregroundColor(appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })

                    } // HStack
                    .frame(maxWidth: Dims.formMaxWidth)

                    Spacer()

                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(appVm.theme.primary.ignoresSafeArea(.all))

            } // VStack

        } // GeometryReader

    }
}

#Preview {
    MemoView(vm: .init(wrappedValue: .init(
        memo: .init(
            id: "123",
            userId: "321",
            title: "Hello, World!",
            description: "Testing one two",
            priority: "low",
            status: "pending",
            visibility: 0,
            frequency: nil,
            triggerAt: 1709222686678,
            updatedAt: 1709222686678,
            createdAt: 1709222686678
        ),
        listener: nil
    )))
    .environmentObject(AppViewModel())
}

//
//  CreateMemoView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct CreateMemoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appVm: AppViewModel
    @StateObject var vm: CreateMemoViewModel

    @FocusState var isFocusingTextfield: Bool

    init(vm: StateObject<CreateMemoViewModel> = .init(wrappedValue: .init(listener: nil))) {
        _vm = vm
    }

    var body: some View {

        GeometryReader { geometry in

            VStack(alignment: .center, spacing: 0) {

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss()
                    }

                VStack(alignment: .leading, spacing: Dims.spacingRegular) {

                    FormTextfieldMultilineComponent(
                        text: $vm.title,
                        title: .constant("Remind me to..."),
                        placeholder: $vm.placeholder,
                        theme: appVm.theme
                    )
                    .focused($isFocusingTextfield)
                    .frame(maxWidth: Dims.formMaxWidth)
                    .onAppear {
                        isFocusingTextfield = true
                    }
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
                                .lineLimit(1)
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

                        Spacer(minLength: 0)

                        Button(action: {
                            vm.createMemo()
                            dismiss()
                        }, label: {
                            Text("Save")
                                .foregroundColor(appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })

                    }
                    .frame(maxWidth: Dims.formMaxWidth)

                    HStack(alignment: .center, spacing: Dims.spacingRegular) {

                        MemoPriorityComponent(
                            priority: $vm.priority,
                            theme: appVm.theme
                        )

                        MemoVisibilityComponent(
                            visibility: $vm.visibility,
                            theme: appVm.theme
                        )

                    }

                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(appVm.theme.primary.ignoresSafeArea(.all))
                .animation(.easeInOut(duration: 0.1), value: vm.title)

            } // VStack

        } // GeometryReader
        .onAppear {
            Haptics.shared.play(.rigid)
        }

    }

}

#Preview {
    CreateMemoView()
        .environmentObject(AppViewModel())
}

//
//  CreateReminderView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct CreateReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: CreateReminderViewModel
    
    @FocusState var isFocusingTextfield: Bool
    
    init(vm: StateObject<CreateReminderViewModel> = .init(wrappedValue: .init())) {
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
                        presentationMode.wrappedValue.dismiss()
                    }
                
                VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                    
                    FormTextfieldMultilineComponent(
                        text: $vm.title,
                        title: .constant("Remind me to..."),
                        placeholder: $vm.placeholder,
                        theme: vm.appVm.theme
                    )
                    .focused($isFocusingTextfield)
                    .frame(maxWidth: Dims.formMaxWidth)
                    .onAppear {
                        isFocusingTextfield = true
                    }
                    .onChange(of: vm.title, perform: { value in
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
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        .sheet(isPresented: $vm.isPresentingDatePickerView) {
                            DatePickerView(date: $vm.triggerAtDate, theme: vm.appVm.theme)
                                .background(ClearBackgroundView())
                        }
                        
                        Menu {
                            Button {
                                vm.frequency = ""
                            } label: {
                                Text("Once")
                            }
                            
                            Button {
                                vm.frequency = "hourly"
                            } label: {
                                Text("Hourly")
                            }
                            
                            Button {
                                vm.frequency = "daily"
                            } label: {
                                Text("Daily")
                            }
                            
                            Button {
                                vm.frequency = "weekly"
                            } label: {
                                Text("Weekly")
                            }
                            
                            Button {
                                vm.frequency = "monthly"
                            } label: {
                                Text("Monthly")
                            }
                            
                            Button {
                                vm.frequency = "yearly"
                            } label: {
                                Text("Yearly")
                            }
                        } label: {
                            Text("\(vm.frequency.isEmpty ? "Repeat" : vm.frequency.capitalized)")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            vm.createReminder()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                    }
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {
                        
                        Button(action: {
                            vm.visibility = vm.visibility == 0 ? 1 : 0
                        }, label: {
                            Text(vm.visibility == 0 ? "Private" : "Public")
                                .foregroundColor(vm.visibility == 0 ? vm.appVm.theme.fontDim : vm.appVm.theme.fontNormal)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                    }
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(vm.appVm.theme.primary.ignoresSafeArea(.all))
                .animation(.easeInOut(duration: 0.1), value: vm.title)
                
            } // VStack
            
        } // GeometryReader
        
    }
    
}

#Preview {
    CreateReminderView()
}

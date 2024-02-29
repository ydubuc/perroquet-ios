//
//  ProfileView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    @ScaledMetric var scale: CGFloat = 1
    
    init(vm: StateObject<ProfileViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(alignment: .center, spacing: Dims.spacingRegular) {
                
                HStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                    let imageSize = (UIFont.preferredFont(forTextStyle: .body).pointSize * 3) * scale
                    
                    Image("perroquet-app-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(imageSize / 2)
                    
                    Text(vm.quote)
                        .foregroundColor(vm.appVm.theme.fontNormal)
                        .font(.body.weight(.regular))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                }
                .frame(maxWidth: Dims.viewMaxWidth2)
                
            } // LazyVStack
            .padding(Dims.spacingRegular)

        } // ScrollView
        .refreshable {
            vm.load()
        }
        
    }
}

#Preview {
    ProfileView()
}

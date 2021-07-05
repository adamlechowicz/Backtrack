//
//  ConfigView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/4/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    @Environment(\.colorScheme) var colorScheme
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    init() {
        UITableView.appearance().tableHeaderView = UIView()
    }
    
    var body: some View {
        VStack{
            Button(action:{
                self.locHelper.doSomethingStupid()
                self.locHelper.toggle()
                    }){
                HStack {
                    Text("Start Backtracking").foregroundColor(self.locHelper.active ? .black : .white)
                }
                    .padding(.horizontal, 40.0)
                    .padding(.vertical, 15.0)
                    .background(Color(self.locHelper.active ? .green : .blue))
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(17.0)
            }.buttonStyle(SimpleButtonStyle())
        }.onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                
            }
        }
        .navigationBarTitle("Home", displayMode: .large)
    }
    
}


struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView().environmentObject(ModelData()).environmentObject(LocationHelper())
    }
}


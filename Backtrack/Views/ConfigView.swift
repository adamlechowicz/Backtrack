//
//  ConfigView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/4/21.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    @Environment(\.colorScheme) var colorScheme
    @State var toggle_iCloudOn: Bool
    @State var filter_selection: Int
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack{
            HStack{
                Text("Backtrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 20.0)
                    .padding(.top, 20.0)
                Text("Config")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .padding(.top, 20.0)
                Spacer()
            }.padding(.top, 20.0)
            List{
                VStack{
                    HStack{
                        Image(systemName: "ruler")
                        Text("Distance Filter")
                        Spacer()
                    }
                    Picker(selection: $filter_selection, label: Text("Distance Filter")) {
                            Text("50m").tag(50)
                            Text("100m").tag(100)
                            Text("200m").tag(200)
                            Text("300m").tag(300)
                            Text("500m").tag(500)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: filter_selection, perform: { value in
                            self.locHelper.setLocationFilter(filter_selection)
                    })
                }.padding(.vertical)
                HStack{
                    Toggle(isOn: $toggle_iCloudOn, label: {
                        Image(systemName: "icloud.fill")
                        Text("iCloud Drive: ")
                        Text(toggle_iCloudOn ? "ON" : "OFF")
                            .bold().foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                    })
                        .onChange(of: toggle_iCloudOn, perform: { value in
                            self.locHelper.iCloudToggle()
                        })
                }.disabled(!self.locHelper.iCloudAvail).padding(.vertical, 7.0).toggleStyle(SwitchToggleStyle(tint: (self.locHelper.active ? .green : .blue)))
            }.listStyle(InsetGroupedListStyle()).onAppear {
                UITableView.appearance().isScrollEnabled = false
            }
            Button(action:{
                self.locHelper.doSomethingStupid()
                self.locHelper.toggle()
                    }){
                HStack {
                    Text(self.locHelper.active ? "Stop Backtracking" : "Start Backtracking").foregroundColor(self.locHelper.active ? .black : .white)
                }
                    .padding(.horizontal, 40.0)
                    .padding(.vertical, 15.0)
                    .background(Color(self.locHelper.active ? .green : .blue))
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(17.0)
            }.buttonStyle(SimpleButtonStyle())
            .padding(.all)
            .padding(.bottom)
        }.background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                
            }
        }
    }
}


struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(toggle_iCloudOn: false, filter_selection: 200).previewDevice("iPhone 8").environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}


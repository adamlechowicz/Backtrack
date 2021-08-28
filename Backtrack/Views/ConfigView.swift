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
    @State var toggle_BacktrackOn: Bool
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    
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
                Button(action: {
                    modelData.setSheet(5)
                    modelData.toggleSheet()
                }, label: {
                    Image(systemName: "info.circle").foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue)).font(.title2)
                }).padding(.trailing, 20.0).padding(.top, 20.0)
            }.padding(.top, 20.0).padding(.bottom, 20.0)
            VStack{
                VStack{
                    HStack{
                        Image(systemName: "ruler").font(.title2).padding(.bottom, 4.0)
                        Spacer()
                        Button(action: {
                            modelData.setSheet(3)
                            modelData.toggleSheet()
                        }, label: {
                            Image(systemName: "info.circle").foregroundColor(.blue).font(.title2)
                        })
                    }
                    HStack{
                        Text("Distance Filter").font(.title2).fontWeight(.medium)
                        Spacer()
                    }
                    Picker(selection: $filter_selection, label: Text("Distance Filter")) {
                            Text("100m").tag(100)
                            Text("200m").tag(200)
                            Text("300m").tag(300)
                            Text("500m").tag(500)
                            Text("1000m").tag(1000)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: filter_selection, perform: { value in
                            self.locHelper.setLocationFilter(filter_selection)
                    })
                }.padding(.all).background(Color(UIColor.systemBackground))
                .cornerRadius(17.0)
                if(screenHeight > 600){
                    Divider().padding(.vertical, 10.0)
                }
                VStack{
                    HStack{
                        Image(systemName: "icloud").font(.title2)
                        Spacer()
                        Button(action: {
                            modelData.setSheet(4)
                            modelData.toggleSheet()
                        }, label: {
                            Image(systemName: "info.circle").foregroundColor(.blue).font(.title2)
                        })
                    }
                    HStack{
                        Text("iCloud Drive Logging").font(.title2).fontWeight(.medium)
                        Spacer()
                    }.padding(.top, 1.0)
                    HStack{
                        Toggle(isOn: $toggle_iCloudOn, label: {
                            Text(toggle_iCloudOn ? "ON" : "OFF").font(.title3).fontWeight(.heavy).foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                        })
                            .onChange(of: toggle_iCloudOn, perform: { value in
                                self.locHelper.iCloudToggle()
                            })
                    }.disabled(!self.locHelper.iCloudAvail)
                }.padding(.all).toggleStyle(SwitchToggleStyle(tint: (self.locHelper.active ? .green : .blue))).background(Color(UIColor.systemBackground))
                    .cornerRadius(17.0)
                if(screenHeight > 600){
                    Divider().padding(.vertical, 10.0)
                }
                Spacer()
            }.padding(.horizontal)
            Button(action:{
                self.locHelper.toggle()
                self.toggle_BacktrackOn = !self.toggle_BacktrackOn
                    }){
                HStack {
                    Text(self.locHelper.active ? "Backtracking ON" : "Backtracking OFF").font(.title2).fontWeight(.bold)
                    Spacer()
                    Toggle(isOn: $toggle_BacktrackOn, label: {
                        Text("None")
                    }).labelsHidden().allowsHitTesting(false)
                }
                    .padding(.horizontal, 30.0)
                    .padding(.vertical, 15.0)
                    .background(Color(self.locHelper.active ? .green : .blue).opacity(0.2))
                    .font(.headline)
                    .cornerRadius(17.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 17)
                            .stroke(Color(self.locHelper.active ? .green : .blue), lineWidth: 4)
                            .shadow(radius: 3)
                    )
            }.buttonStyle(SimpleButtonStyle())
            .padding(.all)
            .padding(.bottom, screenHeight > 600 ? 18.0 : 10.0)
        }.background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.top))
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(toggle_iCloudOn: false, filter_selection: 200, toggle_BacktrackOn: true).environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}


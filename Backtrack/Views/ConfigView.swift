/*
See LICENSE for this file's licensing information.
*/

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    
    //SwiftUI state variables, local to this file
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
                    modelData.toggleSheet()  //Open the info sheet with acknowledgements (version number, etc.)
                }, label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                        .font(.title2)
                })
                .padding(.trailing, 20.0)
                .padding(.top, 20.0)
            }
            .padding(.top, 20.0)
            .padding(.bottom, 20.0)
            VStack{
                VStack{  //Section for adjusting distance filter
                    HStack{
                        Image(systemName: "ruler").font(.title2).padding(.bottom, 4.0)
                        Spacer()
                        Button(action: {
                            modelData.setSheet(3)
                            modelData.toggleSheet()  //Open the info sheet for distance filter
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
                                //set the location filter to value chosen
                        })
                }.padding(.all)
                .background(Color(UIColor(named: "Regular") ?? .gray))
                .cornerRadius(17.0)
                if(screenHeight > 600){  //if not on a 4-inch display, add some extra space
                    Divider().padding(.vertical, 10.0)
                }
                VStack{  //Section for turning on/off iCloud Drive Logging
                    HStack{
                        Image(systemName: "icloud").font(.title2)
                        Spacer()
                        Button(action: {
                            modelData.setSheet(4)
                            modelData.toggleSheet()  //Open the info sheet for iCloud
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
                            Text(toggle_iCloudOn ? "ON" : "OFF")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                        })
                            .onChange(of: toggle_iCloudOn, perform: { value in
                                self.locHelper.iCloudToggle()
                            })
                    }.disabled(!self.locHelper.iCloudAvail) //disable if not signed into iCloud
                }.padding(.all)
                .toggleStyle(SwitchToggleStyle(tint: (self.locHelper.active ? .green : .blue)))
                .background(Color(UIColor(named: "Regular") ?? .gray))
                .cornerRadius(17.0)
                if(screenHeight > 600){  //if not on a 4-inch display, add some extra space
                    Divider().padding(.vertical, 10.0)
                }
                Spacer()
            }.padding(.horizontal)
            Button(action:{
                self.locHelper.toggle() //Turn on (or off) location tracking
                self.toggle_BacktrackOn = !self.toggle_BacktrackOn //change the UI to reflect this
                    }){
                HStack {
                    Text(self.locHelper.active ? "Backtracking ON" : "Backtracking OFF")
                        .font(.title2)
                        .fontWeight(.bold)
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
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(toggle_iCloudOn: false, filter_selection: 200, toggle_BacktrackOn: true).environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}


/*
See LICENSE for this file's licensing information.
*/

import SwiftUI

struct AppView: View {
    @State private var selection = 1  //UI State var for tabbed view, default tab "Config"
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        TabView(selection: $selection) { //root tab view
            ConfigView(toggle_iCloudOn: self.locHelper.iCloudActive, filter_selection: self.locHelper.distanceFilterVal, toggle_BacktrackOn: self.locHelper.active)
                .tabItem {
                    Image(systemName: "gearshape.2.fill")
                    Text("Config")
                }
                .tag(1)
            DataView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("View Data")
                }
                .tag(2)
        }.onAppear(){
            if(self.locHelper.authorisationStatus != .authorizedAlways){
                self.locHelper.requestAuth() //initial request for location access
            }
        }.overlay( //overlay enables us to show informational "Sheets"
            ZStack{
                if modelData.showSheet{
                    ZStack{
                        overlayRect() //show the "material" for the sheet
                        VStack{
                            HStack{  //show close button for sheet
                                Spacer()
                                
                                //if this sheet is one of the first three, it's part of initial
                                //setup and we shouldn't show a close button
                                if(modelData.sheetId > 2){
                                    Button(action: { modelData.toggleSheet() }, label: {
                                        ZStack{
                                            Circle()
                                                .frame(width: 38, height: 38)
                                                .foregroundColor(.gray)
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                        }
                                    }).padding(.trailing, 25.0)
                                }
                            }
                            
                            //if this sheet is the acknowledgements sheet, show that instead of
                            //the standard sheet view
                            if(modelData.sheetId == 5){
                                acknowledgeView()
                            }
                            //if this is the second sheet, it's the location setup sheet, so
                            //show the location setup view
                            else if (modelData.sheetId == 1) {
                                locationSetupView(sheetData[modelData.sheetId])
                                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                Button(action:{
                                    modelData.setSheet(sheetData[modelData.sheetId].nextId)
                                    modelData.toggleSheet()
                                    modelData.toggleSheet()
                                }){
                                    HStack {
                                    Text(sheetData[modelData.sheetId].button).foregroundColor(.white)
                                    }
                                        .padding(.horizontal, 40.0)
                                        .padding(.vertical, 15.0)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .cornerRadius(17.0)
                                }.buttonStyle(SimpleButtonStyle())
                                .padding(.bottom, screenHeight > 600 ? 100.0 : 70.0)
                            }
                            //Otherwise, the standard sheet view is all we need
                            else {
                                sheetView(sheetData[modelData.sheetId])
                                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                //show a bottom button for initial setup sheets
                                if(modelData.sheetId < 3){
                                    Button(action:{
                                        if (modelData.sheetId < 2){
                                            //if it's the first two sheets in the setup, just
                                            //go to the next sheet in the sequence
                                            modelData.setSheet(sheetData[modelData.sheetId].nextId)
                                        } else {
                                            //if this is the last sheet in the sequence,
                                            //just close the sheet with this bottom button
                                            modelData.toggleSheet()
                                        }
                                    }){
                                        HStack {
                                            Text(sheetData[modelData.sheetId].button).foregroundColor(.white)
                                        }
                                            .padding(.horizontal, 40.0)
                                            .padding(.vertical, 15.0)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .cornerRadius(17.0)
                                    }.buttonStyle(SimpleButtonStyle())
                                    .padding(.bottom, screenHeight > 600 ? 100.0 : 70.0)
                                } else {
                                    EmptyView()
                                }
                            }
                        }.padding(.top, 100.0)
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    .animation(.easeInOut(duration: 0.3))
                } else {
                    EmptyView()
                }
            }
        )
        .accentColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
        //set accent color for whole app based on status of location helper
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(LocationHelper()).environmentObject(ModelData(LocationHelper()))
    }
}

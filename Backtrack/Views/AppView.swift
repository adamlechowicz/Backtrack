//
//  AppView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 4/9/20.
//

import SwiftUI

struct AppView: View {
    @State private var selection = 1
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    @State var insertEdge: Edge = .bottom
    @State var removeEdge: Edge = .bottom
    
    var body: some View {
        TabView(selection: $selection) {
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
                self.locHelper.requestAuth(always: true)
            }
            do{
                let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
                let fh = dir.appendingPathComponent("test.txt")
                NSLog(fh.absoluteString)
                do {
                    try "Hello World".write(to: fh, atomically: true, encoding: .utf8)
                } catch {
                    NSLog("Error")
                }
            } catch let error as NSError {
                NSLog("Problem opening the appropriate file: \(error)")
            }
        }.overlay(
            ZStack{
                if modelData.showSheet{
                    ZStack{
                        overlayRect()
                        VStack{
                            HStack{
                                Spacer()
                                if(modelData.sheetId > 2){
                                    Button(action: { modelData.toggleSheet() }, label: {
                                        ZStack{
                                            Circle().frame(width: 38, height: 38).foregroundColor(.gray)
                                            Image(systemName: "xmark").foregroundColor(.white).font(.title2)
                                        }
                                    }).padding(.trailing, 25.0)
                                }
                            }
                            if(modelData.sheetId == 5){
                                acknowledgeView()
                            } else if (modelData.sheetId == 1) {
                                //setupView()
                                sheetView(sheetData[modelData.sheetId]).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
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
                                .padding(.bottom, 70.0)
                            } else {
                                sheetView(sheetData[modelData.sheetId]).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                if(sheetData[modelData.sheetId].button != ""){
                                    Button(action:{
                                        if (modelData.sheetId < 2){
                                            modelData.setSheet(sheetData[modelData.sheetId].nextId)
                                            modelData.toggleSheet()
                                            modelData.toggleSheet()
                                        } else {
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
                                    .padding(.bottom, 70.0)
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
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(LocationHelper()).environmentObject(ModelData(LocationHelper()))
    }
}

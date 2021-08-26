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
    
    var body: some View {
        TabView(selection: $selection) {
            ConfigView(toggle_iCloudOn: self.locHelper.iCloudActive, filter_selection: self.locHelper.distanceFilterVal)
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
                            sheetView(sheetData[modelData.sheetId])
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

struct overlayRect: View{
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View{
        RoundedRectangle(cornerRadius: 30.0)
            .frame(width: screenWidth, height: screenHeight+10.0)
                .foregroundColor(Color(UIColor(named: "Regular") ?? .white))
                .padding(5)
                .padding(.top, 80.0)
                .shadow(color: Color(UIColor(named: "ReverseShadow") ?? .black), radius: 20.0)
    }
}

struct sheetView: View{
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var sheet: Sheet

    var images = [UIImage]()
    let animatedImage: UIImage
    
    init(_ sheet: Sheet){
        for name in sheet.imageNames{
            images.append(UIImage(named: name)!)
        }
        for name in sheet.imageNames.reversed(){
            if(sheet.id > 3){
                break
            }
            images.append(UIImage(named: name)!)
        }
        self.animatedImage = UIImage.animatedImage(with: images, duration: sheet.duration)!
        self.sheet = sheet
    }
    
    struct mapAnimation: UIViewRepresentable {

        var vWidth : CGFloat
        var vHeight : CGFloat
        var animatedImage : UIImage
        
        func makeUIView(context: Self.Context) -> UIView {
            let someView = UIView(frame: CGRect(x: 0, y: 0
            , width: UIScreen.main.bounds.size.width, height: vHeight))
            
            let rect = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
            let someImage = UIImageView(frame: rect)
            someImage.clipsToBounds = true
            someImage.layer.cornerRadius = 20
            someImage.autoresizesSubviews = true
            someImage.contentMode = UIView.ContentMode.scaleAspectFill

            someImage.image = animatedImage

            someView.addSubview(someImage)

            return someView
          }

        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<mapAnimation>) {}
    }
    
    var body: some View{
        VStack{
            Text(sheet.title).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().padding(.all)
            mapAnimation(vWidth: screenWidth-40.0, vHeight: (screenWidth-40.0)/3, animatedImage: self.animatedImage).padding(.leading, 20.0).frame(width: screenWidth, height: (screenWidth)/3)
            Text(sheet.body).padding(.horizontal, 25.0)
            if(sheet.button != ""){
                Button(action:{
                    //do something
                        }){
                    HStack {
                        Text(sheet.button).foregroundColor(.white)
                    }
                        .padding(.horizontal, 40.0)
                        .padding(.vertical, 15.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(17.0)
                }.buttonStyle(SimpleButtonStyle())
                .padding(.all)
                .padding(.bottom)
            } else {
                EmptyView()
            }
            Spacer()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(LocationHelper()).environmentObject(ModelData(LocationHelper()))
    }
}

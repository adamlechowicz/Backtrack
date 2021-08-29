/*
See LICENSE for this file's licensing information.
*/

import SwiftUI

struct overlayRect: View{ //"material" for informational sheets
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View{
        RoundedRectangle(cornerRadius: 30.0)
            .frame(width: screenWidth, height: screenHeight+10.0)
                .foregroundColor(Color(UIColor(named: "Regular") ?? .white))
                .padding(5)
                .padding(.top, 80.0)
            .shadow(color: Color(UIColor(named: "ReverseShadow") ?? .black).opacity(0.8), radius: 10.0)
    }
}

struct sheetView: View{ //standard sheet view for informational sheets
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var sheet: Sheet

    var images = [UIImage]()
    let animatedImage: UIImage
    
    init(_ sheet: Sheet){
        //get the names of frames for the animated image and initialize it
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
    
    var body: some View{
        VStack{
            Text(sheet.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.top, screenHeight > 600 ? 18.0 : 7.0).padding(.horizontal)
            ScrollView{
                topAnimation(vWidth: screenWidth-40.0, vHeight: (screenWidth-40.0)/3, animatedImage: self.animatedImage)
                    .padding(.leading, 20.0)
                    .frame(width: screenWidth, height: (screenWidth)/3)
                Text(sheet.body)
                    .padding(.horizontal, 25.0)
            }
        }
    }
}

struct locationSetupView: View{ //specific sheet view for location permission setup sheet
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var sheet: Sheet
    
    init(_ sheet: Sheet){
        self.sheet = sheet
    }
    
    var body: some View{
        VStack{
            Text(sheet.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.top, screenHeight > 600 ? 18.0 : 7.0).padding(.horizontal)
            ScrollView{
                topAnimation(vWidth: screenWidth-40.0, vHeight: (screenWidth-40.0)/3, animatedImage: UIImage(named: "arrowFrame1")!)
                    .padding(.leading, 20.0)
                    .frame(width: screenWidth, height: (screenWidth)/3)
                VStack{
                    Text("First, let’s get your permissions set up.")
                    Divider()
                    //open Settings app to set location permissions
                    Button (action: {openURL(UIApplication.openSettingsURLString)}) {
                        VStack{
                            HStack{
                                Image(systemName: "1.circle.fill")
                                    .font(.title3).frame(width: 30)
                                Image(systemName: "gear")
                                    .font(.title3).padding(.leading, 2.0).foregroundColor(.gray)
                                Text("Settings")
                                    .font(.headline)
                                Image(systemName: "arrowshape.bounce.right")
                                    .font(.headline)
                                if (screenHeight > 600){
                                    Image("AcknowledgeIcon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .cornerRadius(7.0)
                                }
                                Text("Backtrack")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                            }.padding(.bottom, 1.0)
                        }.padding(.vertical, 5.0)
                        //.background(Color.gray)
                        .foregroundColor(.blue)
                    }
                    Divider()
                    //set location permissions (visual example)
                    VStack{
                        HStack{
                            Image(systemName: "2.circle.fill")
                                .font(.title3).frame(width: 30)
                            Text("Change ")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 5.0)
                                .fixedSize(horizontal: false, vertical: true)
                            HStack{
                                if (screenHeight > 600){
                                    ZStack{
                                        Image(systemName: "location.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                    }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(8.0).padding(.leading, 2.0)
                                }
                                Text("Location").padding(.vertical, 8.0).padding(.leading, 2.0)
                                Spacer()
                                Text("Always").bold().padding(.vertical, 8.0).foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .font(.headline).foregroundColor(.gray)
                                    .padding(.trailing, 2.0)
                            }.background(Color(UIColor.systemGroupedBackground)).cornerRadius(12.0)
                            Spacer()
                        }.padding(.bottom, 1.0)
                    }
                    Divider()
                    Text(sheet.body)
                        .padding(.bottom)
                }.padding(.horizontal, screenHeight > 600 ? 25.0 : 15.0)
            }
        }
    }
}

struct topAnimation: UIViewRepresentable { //wrapper class to show a GIF-style animation

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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<topAnimation>) {}
}

//
//  SheetView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 8/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct overlayRect: View{
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
    
    struct topAnimation: UIViewRepresentable {

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
    
    var body: some View{
        VStack{
            Text(sheet.title).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().padding(.top, screenHeight > 600 ? 18.0 : 7.0).padding(.horizontal)
            ScrollView{
                topAnimation(vWidth: screenWidth-40.0, vHeight: (screenWidth-40.0)/3, animatedImage: self.animatedImage).padding(.leading, 20.0).frame(width: screenWidth, height: (screenWidth)/3)
                Text(sheet.body).padding(.horizontal, 25.0)
            }
        }
    }
}

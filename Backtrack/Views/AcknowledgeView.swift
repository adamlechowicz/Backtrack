//
//  AcknowledgeView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 8/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct acknowledgeView: View{
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    var body: some View{
        VStack{
            HStack{
                Image("AcknowledgeIcon")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(17.0)
                VStack{
                    HStack{
                        Text("Backtrack")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 1.0)
                        Spacer()
                    }
                    HStack{
                        Text("Version ")+Text(versionNumber)+Text("     Build ").font(.subheadline)+Text(buildNumber).font(.subheadline)
                        Spacer()
                    }
                }.padding(.leading, 5.0)
                Spacer()
            }.padding(.bottom, screenHeight > 600 ? 10.0 : 0.0).padding(.top, screenHeight > 600 ? 0.0 : -20.0)
            VStack{
                Divider()
                Button (action: {openURL("https://drive.google.com/file/d/1NfjuFBOOQwoXSBjXEOhr0fHBuzaq-RAp/view?usp=sharing")}) {
                    VStack{
                        HStack{
                            Image(systemName: "hand.raised.fill")
                                .font(.headline).frame(width: 30)
                            Spacer()
                        }.padding(.bottom, 1.0)
                        HStack{
                            Text("Privacy Policy")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 5.0)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }

                    .padding(.trailing, 9.0)
                    .padding(.leading, 3.0)
                    .padding(.vertical, 5.0)
                    //.background(Color.gray)
                    .foregroundColor(.blue)
                }
            }
            VStack{
                Divider()
                Button (action: {openURL("https://github.com/adamlechowicz/Backtrack")}) {
                    VStack{
                        HStack{
                            Image(systemName: "chevron.left.slash.chevron.right")
                                .font(.headline).frame(width: 40)
                            Spacer()
                        }.padding(.bottom, 1.0)
                        HStack{
                            Text("Source Code")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 5.0)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }
                    .padding(.trailing, 9.0)
                    .padding(.leading, 3.0)
                    .padding(.vertical, 5.0)
                    //.background(Color.gray)
                    .foregroundColor(.blue)
                }
            }
            VStack{
                Divider()
                Button (action: {openURL("https://github.com/adamlechowicz/Backtrack/blob/main/LICENSE")}) {
                    VStack{
                        HStack{
                            Image(systemName: "doc.text.fill")
                                .font(.headline).frame(width: 30)
                            Spacer()
                        }.padding(.bottom, 1.0)
                        HStack{
                            Text("MIT License")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 5.0)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                    }
                    .padding(.trailing, 9.0)
                    .padding(.leading, 3.0)
                    .padding(.vertical, 5.0)
                    //.background(Color.gray)
                    .foregroundColor(.blue)
                }
            }
            Spacer()
            VStack{
                HStack{
                    Text("Contact/Feedback")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.top, screenHeight > 600 ? 30.0 : 10.0).padding(.bottom, 6.0).padding(.leading, 5.0)
                HStack{
                    Spacer()
                    
                    Button (action: {
                            openURL("mailto:alechowicz@umass.edu")
                    }){
                        HStack{
                            Image(systemName: "envelope.fill")
                                .font(.title)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 30.0)
                        .padding(.vertical, 5.0)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15.0)
                        .shadow(radius: 1.0, x: 1.0, y: 1.0)
                    }.buttonStyle(ItemButtonStyle())
                    
                    Spacer()
                    
                    Button (action: {
                            openURL("https://github.com/adamlechowicz")
                    }){
                        HStack{
                            Image("github")
                                .resizable()
                                .frame(width:30, height:30)
                                .foregroundColor(Color(UIColor(named: "BlackWhite") ?? .white))
                        }
                        .padding(.horizontal, 30.0)
                        .padding(.vertical, 5.0)
                        .background(Color(UIColor(named: "ReverseShadow") ?? .black))
                        .cornerRadius(15.0)
                        .shadow(radius: 1.0, x: 1.0, y: 1.0)
                    }.buttonStyle(ItemButtonStyle())
                    
                    Spacer()
                    
                    Button (action: {
                            openURL("https://www.linkedin.com/in/adamlechowicz/")
                    }){
                        HStack{
                            Image("linkedin")
                                .resizable()
                                .frame(width:25, height:25)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 30.0)
                        .padding(.vertical, 7.5)
                        .background(Color(UIColor(named: "InColor") ?? .blue))
                        .foregroundColor(.white)
                        .cornerRadius(15.0)
                        .shadow(radius: 1.0, x: 1.0, y: 1.0)
                    }.buttonStyle(ItemButtonStyle())
                    
                    Spacer()
                }
                Spacer()
                Text("© 2021 Adam Lechowicz\nReleased under MIT License.")
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top)
            }.padding(.bottom, 70.0)
            Spacer()
        }.padding(.horizontal, 20.0)
    }
}

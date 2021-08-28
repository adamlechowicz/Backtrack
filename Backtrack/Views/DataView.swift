/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct DataView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    
    @State private var intervalSet = false
    @State private var selectedDate = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        if(modelData.ready){
            ZStack{
                VStack{
                    if(modelData.data.count > 0 && modelData.dataReady){
                        MapView(points: modelData.data).environmentObject(modelData)
                    } else if (modelData.dataReady){
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text(" No data available for the selected date.\n ❌🗓").font(.title2).fontWeight(.heavy).foregroundColor(Color.gray).multilineTextAlignment(.center).padding(.horizontal, 40.0)
                                Spacer()
                            }
                            Spacer()
                        }.background(Color(UIColor.systemGroupedBackground))
                    } else {
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text("loading...").font(.title).fontWeight(.heavy).foregroundColor(Color.gray).multilineTextAlignment(.center).padding(.horizontal, 40.0)
                                Spacer()
                            }
                            Spacer()
                        }.background(Color(UIColor.systemGroupedBackground))
                    }
                }
                VStack{
                    VStack{
                        HStack{
                            Text("Backtrack")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading, 20.0)
                                .padding(.top, 20.0)
                            Text("Data")
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .padding(.top, 20.0)
                            Spacer()
                            Button(action:{
                                let path = locHelper.getFileURL().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://").replacingOccurrences(of: "/backtrack.csv", with: "")
                                let url = URL(string: path)!
                                UIApplication.shared.open(url)
                            }){
                                Image(systemName: "square.and.arrow.down.fill")
                                    .padding(.horizontal, 20.0)
                                    .padding(.top, 20.0)
                                    .foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                                    .font(.title)
                            }.buttonStyle(SimpleButtonStyle())
                        }.padding(.top, 20.0)
                        ZStack{
                            HStack{
                                Text("Date:")
                                    .fontWeight(.bold)
                                    .padding(.leading, 20.0)
                                Spacer()
                            }
                            DatePicker(selection: $selectedDate, in: modelData.dateBoundaries, displayedComponents: .date) {}.labelsHidden()
                                .id(selectedDate)
                                .onChange(of: selectedDate, perform: { value in
                                    self.modelData.setDate(selectedDate)
                            }).frame(width: UIScreen.main.bounds.width)
                        }.padding(.vertical)
                    }.background(Blur().edgesIgnoringSafeArea(.top))
                    Spacer()
                }
            }.edgesIgnoringSafeArea(.bottom)
        } else {
            VStack{
                HStack{
                    Text("Backtrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 20.0)
                        .padding(.top, 20.0)
                    Text("Data")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .padding(.top, 20.0)
                    Spacer()
                }.padding(.vertical, 20.0)
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text(" Come back here once you've logged some location data!\n 🏃‍♀️💨").font(.title2).fontWeight(.heavy).foregroundColor(Color.gray).multilineTextAlignment(.center).padding(.horizontal, 40.0)
                        Spacer()
                    }
                    Spacer()
                }.background(Color(UIColor.black))
            }
        }
    }

}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

func openURL(_ sUrl: String) {
    if let url = URL(string: "\(sUrl)"), !url.absoluteString.isEmpty {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
            .environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}

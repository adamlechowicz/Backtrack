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
    @State private var selectedStart = Date()
    @State private var selectedEnd = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        if(modelData.ready){
            ZStack{
                VStack{
                    if(modelData.data.count > 0 && modelData.intervalReady){
                        MapView(points: modelData.data).environmentObject(modelData)
                    } else if (modelData.intervalReady){
                        Text("Select a range of dates to look at.")
                        Spacer()
                    } else {
                        Text("loading...")
                        Spacer()
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
                        }.padding(.top, 20.0)
                        HStack{
                            VStack {
                                DatePicker(selection: $selectedStart, in: modelData.dateBoundaries, displayedComponents: .date) {
                                    Text("Start Date").bold()
                                }
                                DatePicker(selection: $selectedEnd, in: modelData.dateBoundaries, displayedComponents: .date) {
                                    Text("End Date").bold()
                                }
                            }
                            .padding(.all)
                            Button(action:{ self.modelData.setInterval(selectedStart, selectedEnd) }){
                                HStack {
                                    Text("Load").foregroundColor(self.locHelper.active ? .black : .white)
                                }
                                    .padding(.horizontal, 15.0)
                                    .padding(.vertical, 15.0)
                                    .background(Color(self.locHelper.active ? .green : .blue))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(17.0)
                            }.buttonStyle(SimpleButtonStyle())
                            .padding(.all)
                        }
                    }.background(Blur())
                    Spacer()
                }
            }.navigationTitle("Backtrack").edgesIgnoringSafeArea(.vertical)
        } else {
            Text("Make sure you have data logged!").navigationTitle("Backtrack")
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

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
            .environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}

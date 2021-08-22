/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct DataView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedStart = Date()
    @State private var selectedEnd = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            if(modelData.ready){
                VStack{
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
                                Text("Load").foregroundColor(colorScheme == .dark ? .black : .white)
                            }
                                .padding(.horizontal, 15.0)
                                .padding(.vertical, 15.0)
                                .background(Color(self.locHelper.active ? (UIColor(named: "EmeraldGreen") ?? .green) : .blue))
                                .foregroundColor(.white)
                                .font(.headline)
                                .cornerRadius(17.0)
                        }.buttonStyle(SimpleButtonStyle())
                        .padding(.all)
                    }
                    Spacer()
                    if(modelData.data.count > 0){
                        MapView(points: modelData.data)
                    } else {
                        Text("Select a range of dates to look at.")
                        Spacer()
                    }
                }.navigationTitle("Backtrack")
            } else {
                Text("Make sure you have data logged!").navigationTitle("Landmarks")
            }
        }.navigationTitle("Landmarks")
    }

}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
            .environmentObject(ModelData(LocationHelper())).environmentObject(LocationHelper())
    }
}

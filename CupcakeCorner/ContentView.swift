//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ilkhomzhon on 13.04.2022.
//

import SwiftUI

struct Response: Codable {
    let results: [MyResult]
}

struct MyResult: Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
}

struct ContentView: View {
    @State private var results = [MyResult]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let data = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data.0) {
                self.results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

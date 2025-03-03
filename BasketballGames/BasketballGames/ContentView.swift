//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable, Identifiable {
    let id: Int
    let team: String
    let opponent: String
    let date: String
    let isHomeGame: Bool
    let score: Score
    
    struct Score: Codable {
        let unc: Int
        let opponent: Int
    }
    
    var teamDisplay: String {
        team
    }
    
    var locationDisplay: String {
        isHomeGame ? "Home" : "Away"
    }
    
    var result: String {
        score.unc > score.opponent ? "W" : "L"
    }
    
    var scoreDisplay: String {
        "\(score.unc) - \(score.opponent)"
    }
    
    var formattedDate: String {
        return date
    }
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(games) { game in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(game.team)
                                .foregroundColor(game.team == "Men" ? .blue : .pink)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(game.isHomeGame ? "Home" : "Away")
                                .font(.subheadline)
                        }
                        
                        Text("vs. \(game.opponent)")
                            .font(.headline)
                        
                        Text(game.date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("UNC: \(game.score.unc)")
                            Spacer()
                            Text("\(game.opponent): \(game.score.opponent)")
                        }
                        .padding(.top, 2)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedGames = try JSONDecoder().decode([Game].self, from: data)
            games = decodedGames
        } catch {
            print("Failed to load: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  PokerTracker
//
//  Created by Reece on 3/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var players: [PlayerData]
    
    @State private var presentAddPlayer = false
    @State private var playerToUpdate: PlayerData?
    @State private var presentSelectedBuyIn = false
    @State private var presentSelectedBuyOut = false
    @State private var presentBuyIn = false
    @State private var presentBuyOut = false
    
    @State private var username: String = ""
    @State private var amount: String = ""
    
    @State private var selection: Set<String> = []
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack {
                        Spacer().frame(width: 15)
                        Text("Player Name")
                        Spacer()
                        Text("Balance Owed")
                        Spacer().frame(width: 15)
                    }
                    .padding([.top, .bottom], 10)
                    .zIndex(1)
                    .foregroundColor(Color.white)
                    .background(Color(red: 40 / 255, green: 40 / 255, blue: 60 / 255).opacity(0.6))
                    
                    .toolbar {
                        Button() {
                            presentAddPlayer = true
                        }
                        label: {
                            Label("New Player", systemImage: "plus")
                                .foregroundColor(.blue)
                        }
                        .alert("Add New Player", isPresented: $presentAddPlayer, actions: {
                            TextField("Name", text: $username)
                            TextField("Balance", text: $amount)
                            
                            Button("Add", action: {
                                addPlayer(username, amount)
                                username = ""
                                amount = ""
                            })
                            Button("Cancel", role: .cancel, action: {
                            })
                        })
                        
//                        Menu() {
//                            Button("Clear Storage") {
//                                clearStorage()
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis")
//                        }
                    }

                    List(players, id: \.id, selection: $selection) { player in
                        HStack(spacing: 0) {
                            Text("    ")
                            Image(systemName: selection.contains(player.id) ? "checkmark.circle.fill" : "circle")
                            Text("    " + player.name)
                            Spacer()
                            Text(player.balance)
                        }
                        .onTapGesture {
                            if selection.contains(player.id) {
                                selection.remove(player.id)
                            } else {
                                selection.insert(player.id)
                            }
                        }
                      .listRowInsets(.init(top: 15, leading: 0, bottom: 15, trailing: 15))
                        .foregroundColor(Color.white)
//                        .listRowBackground(
//                            Color(red: 0, green: 102 / 255, blue: 0)
//                                .opacity(selection.contains(player.id) ? 0.6 : 0) // Change opacity when selected
//                        )
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button("Delete") {
                                delPlayer(player)
                            }
                            .tint(.red)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            #if os(iOS)
                                NavigationLink("Details", value: player)
                                    .tint(.blue)
                                
                                Button("Buy Out") {
                                    presentBuyOut = true
                                    playerToUpdate = player
                                }
                                .tint(.red)
                            
                                Button("Buy In") {
                                    presentBuyIn = true
                                    playerToUpdate = player
                                }
                                .tint(.green)
                            #else
                                Button("Buy In") {
                                    presentBuyIn = true
                                    playerToUpdate = player
                                }
                                .tint(.green)
                                
                                Button("Buy Out") {
                                    presentBuyOut = true
                                    playerToUpdate = player
                                }
                                .tint(.red)
                                
                                NavigationLink("Details", value: player)
                                    .tint(.blue)
                            #endif
                        })
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .background {
                        Image("pokerBackground")
                            .resizable()
                            .scaledToFill()
                            .colorMultiply(Color.indigo)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom)
                    }
                    .alert("Buy In Amount", isPresented: $presentBuyIn, actions: {
                        TextField("0.00", text: $amount)
                        
                        Button("Update", action: {
                            if let player = playerToUpdate {
                                player.updateBalance(amount: amount, increment: true, date: nil)
                                amount = ""
                            }
                        })
                        Button("Cancel", role: .cancel, action: {
                        })
                    })
                    
                    .alert("Buy Out Amount", isPresented: $presentBuyOut, actions: {
                        TextField("0.00", text: $amount)
                        
                        Button("Update", action: {
                            if let player = playerToUpdate {
                                player.updateBalance(amount: amount, increment: false, date: nil)
                                amount = ""
                            }
                        })
                        Button("Cancel", role: .cancel, action: {
                        })
                    })
                    .navigationDestination(for: PlayerData.self) { player in
                        DetailView(player: player)
                    }
                    
                    HStack(spacing: 20) {
                        Text("Overall Pot: ")
                        Spacer()
                        Text(calculatePot())
                    }
                    .padding(15)
                    .foregroundColor(Color.white)
                    .background(Color(red: 40 / 255, green: 40 / 255, blue: 60 / 255).opacity(0.3))
                    
                    HStack(spacing: 20) {
                        Spacer()
                        Button() {
                            presentSelectedBuyIn = true
                        }
                        label: {
                            Label("Buy In", systemImage: "plus")
                                .padding(10)
                                .frame(width: 150, height: 30)
                        }
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 40,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                        )
                        .alert("Selected: Buy In", isPresented: $presentSelectedBuyIn, actions: {
                            TextField("Amount", text: $amount)
                            
                            Button("Update", action: {
                                for selected in selection {
                                    updatePlayerBalance(identification: selected, amount: amount, increment: true)
                                }
                                amount = ""
                                selection = []
                            })
                            Button("Cancel", role: .cancel, action: {
                            })
                        })

                        Button() {
                            presentSelectedBuyOut = true
                        }
                        label: {
                            Label("Buy Out", systemImage: "minus")
                                .padding(10)
                                .frame(width: 150, height: 30)
                        }
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 40,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                        )
                        .alert("Selected: Buy Out", isPresented: $presentSelectedBuyOut, actions: {
                            TextField("Amount", text: $amount)
                            
                            Button("Update", action: {
                                for selected in selection {
                                    updatePlayerBalance(identification: selected, amount: amount, increment: false)
                                }
                                amount = ""
                                selection = []
                            })
                            Button("Cancel", role: .cancel, action: {
                            })
                        })
                        Spacer()
                    }
                    .padding([.top, .bottom], 20)
                    .zIndex(1)
                    .background(Color(red: 40 / 255, green: 40 / 255, blue: 60 / 255).opacity(0.6))
                }
                
                Color(red: 40 / 255, green: 40 / 255, blue: 60 / 255)
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
            }
        }
        .navigationTitle("Poker Tracker")
        .foregroundColor(.blue)

    }
    
    func addPlayer(_ player: String, _ amount: String) {
        let player = PlayerData(name: player, balance: amount) // Create the Player
        
        context.insert(player) // Add Player to the data context
    }
    
    func delPlayer(_ player: PlayerData) {
        context.delete(player)
    }
    
    func updatePlayerBalance(identification: String, amount: String, increment: Bool) {
        let matched = players.first(where: { $0.id == identification })
        matched?.updateBalance(amount: amount, increment: increment, date: nil)
    }
    
    func calculatePot() -> String {
        var potValue: Double = 0.00
        var formattedPot: String
        
        for player in players {
            potValue += player.getBalance()
        }
        
        formattedPot = String(format: "%.2f", potValue)
        if Double(formattedPot) == 0 { formattedPot = "0.00" }

        return formattedPot
    }
    
    func clearStorage() {
        do {
            try context.delete(model: PlayerData.self)
            print("Storage cleared successfully")
        } catch {
            print("Error clearing storage: \(error)")
        }
    }
}

#Preview {
    ContentView()
}


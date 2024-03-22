//
//  DetailViewMacOS.swift
//  PokerTracker
//
//  Created by Reece on 3/22/24.
//

import SwiftUI

struct DetailViewMacOS: View {
    let player: PlayerData

    let columns: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("cardBackground")
                    .resizable()
                    .scaledToFill()
                    .colorMultiply(Color.indigo)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Name:")
                            .padding(.top, 10)
                            .fontWeight(.semibold)
                        Text(player.name)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                        
                        Text("Balance Owed:")
                            .fontWeight(.semibold)
                        Text(player.balance)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                        
                        Text("UUID:")
                            .fontWeight(.semibold)
                        Text(player.id)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                        
                        Text("Transaction History:")
                            .fontWeight(.semibold)
                    }
                    
                    ScrollView {
                        VStack {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                                ForEach(player.amountHistory.indices, id: \.self) { index in
                                    Text(player.amountHistory[index])
                                    Text(player.dateHistory[index])
                                }
                            }
                        }
                        .frame(maxWidth: 280)
                    }
                    .offset(x: 5)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button() {
                            player.undoTransaction()
                        } label: {
                            Label("Undo", systemImage: "arrow.uturn.backward.circle")
                                .padding(10)
                                .frame(width: 100, height: 25)
                        }
                        .disabled(player.amountHistory.count <= 1)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 40,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                        )
                        
                        Button() {
                            player.redoTransaction()
                        } label: {
                            Label("Redo", systemImage: "arrow.uturn.forward.circle")
                                .padding(10)
                                .frame(width: 100, height: 25)
                        }
                        .disabled(player.amountsDeleted.count < 1 || player.amountsDeleted.isEmpty)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 40,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                        )

                        Button() {
                            player.clearCache()
                        } label: {
                            Label("Clear", systemImage: "xmark.circle")
                                .padding(10)
                                .frame(width: 100, height: 25)
                        }
                        .disabled(player.amountsDeleted.isEmpty)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 40,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 40
                            )
                        )
                    }
                    .padding(10)
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
    }
}

#Preview {
    DetailViewMacOS(player: PlayerData(name: "John", balance: "0.00"))
}

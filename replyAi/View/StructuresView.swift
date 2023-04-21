//
//  StructuresView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import SwiftUI

struct StructuresView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                    HStack {
                        Image("avatar-3")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 64, height: 64)
                        Text("Buddy")
                            .padding(.leading, 8.0)
                    }
                }
            }
            .navigationTitle("Structures")
            .navigationBarItems(leading: Button(action: {
                
            }, label: {
                Label("Edit", systemImage: "pencil")
            }), trailing: Button(action: {
                
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .leading)
            })
        }
    }
}

struct StructuresView_Previews: PreviewProvider {
    static var previews: some View {
        StructuresView()
    }
}

//
//  StructuresView.swift
//  replyAi
//
//  Created by Benjamin Surrey on 11.04.23.
//

import SwiftUI

struct ChatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var chats: FetchedResults<Chat>
    
    var body: some View {
        NavigationView {
            List {
                Section { 
                    NavigationLink(destination: ChatView()) {
                        HStack {
                            Image("avatar-face-1")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.red)
                                .frame(width: 48, height: 48)
                            Text("Buddy")
                                .padding(.leading, 8.0)
                        }
                    }
                }
                
                ForEach(chats) { chat in
                    NavigationLink(destination: ChatView(chat: chat)) {
                        HStack {
                            Image("\(chat.icon ?? "avatar-1")")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.red)
                                .frame(width: 48, height: 48)
                            Text("\(chat.title!)")
                                .padding(.leading, 8.0)
                        }
                    }
                }
                .onDelete(perform: deleteChats)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Chats")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .trailing)
            })
            
        }
    }
    
    private func deleteChats(offsets: IndexSet) {
        withAnimation {
            offsets.map { chats[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}

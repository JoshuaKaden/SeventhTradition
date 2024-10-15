//
//  CollectionsView.swift
//  SeventhTradition
//
//  Created by Joshua Kaden on 10/14/24.
//

import SwiftData
import SwiftUI

struct CollectionsView: View {
    
    @Binding var meeting: Meeting?
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Collection.date, order: .reverse) private var collections: [Collection]
    
    @State private var selectedCollection: Collection?
    
    var body: some View {
        List(selection: $selectedCollection) {
            ForEach(collections.filter({ $0.meeting == meeting })) { collection in
                NavigationLink(destination: CollectionView(collection: collection)) {
                    HStack {
                        Text(collection.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(collection.amount.formatted(.currency(code: "USD")))
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Collections")
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let new = Collection(date: Date())
            modelContext.insert(new)
            meeting?.collections?.append(new)
            new.meeting = meeting
        }
        try? modelContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let collections = collections.filter({ $0.meeting == meeting })
        withAnimation {
            for index in offsets {
                modelContext.delete(collections[index])
            }
        }
        try? modelContext.save()
    }
}

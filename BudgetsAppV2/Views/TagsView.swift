//
//  TagsView.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 18/03/26.
//


import SwiftUI

struct TagsView: View {
    
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @Binding var selectedTags: Set<Tag>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags) { tag in
                    Text(tag.name ?? "")
                        .padding(10)
                        .background(selectedTags.contains(tag) ? .blue : .gray)
                        .clipShape(.capsule)
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                }
            }.foregroundStyle(.white)
        }
    }
}

struct TagsViewContainer: View {
    
    @State var selectedTags: Set<Tag> = []
    
    var body: some View {
        TagsView(selectedTags: $selectedTags)
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

#Preview {
    TagsViewContainer()
}

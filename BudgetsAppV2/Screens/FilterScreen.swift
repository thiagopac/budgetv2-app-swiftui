//
//  FilterScreen.swift
//  BudgetsAppV2
//
//  Created by Thiago Castro on 19/03/26.
//


import SwiftUI
import CoreData

struct FilterScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var filteredExpenses: [Expense] = []
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var selectedSortOption: SortOptions? = nil
    @State private var selectedSortDirection: SortDirection = .asc
    
    private func filterTags() {
        
        if selectedTags.isEmpty {
            return
        }
        
        let selectedTagNames = selectedTags.map { $0.name }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByPrice() {
        
        guard let startPrice = startPrice,
              let endPrice = endPrice else { return }
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
        
        do {
            try filteredExpenses = context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByTitle() {
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        
        do {
            try filteredExpenses = context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByDate() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            try filteredExpenses = context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private enum SortOptions: CaseIterable, Identifiable {
        case title
        case date
        
        var id: SortOptions {
            return self
        }
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .date:
                return "Date"
            }
        }
        
        var key: String {
            switch self {
            case .title:
                return "title"
            case .date:
                return "dateCreated"
            }
        }
    }
    
    private enum SortDirection: CaseIterable, Identifiable {
        case asc
        case desc
        
        var id: SortDirection {
            return self
        }
        
        var title: String {
            switch self {
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
            }
        }
    }
    
    private func performSort() {
        
        guard let sortOptiion = selectedSortOption else { return }
        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortOptiion.key, ascending: selectedSortDirection == .asc ? true : false)]
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    var body: some View {
        List {
            
            Section("Sort") {
                Picker("Sort Options", selection: $selectedSortOption) {
                    Text("Select").tag(Optional<SortOptions>(nil))
                    ForEach(SortOptions.allCases) { option in
                        Text(option.title).tag(Optional(option))
                    }
                }
                
                Picker("Sort Direction", selection: $selectedSortDirection) {
                    Text("Select").tag(SortDirection.asc)
                    ForEach(SortDirection.allCases) { direction in
                        Text(direction.title).tag(direction)
                    }
                }
                
                Button("Sort") {
                    performSort()
                }
            }
            
            Section("Filter by tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, filterTags)
            }
            
            Section("Filter by price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search") {
                    filterByPrice()
                }
            }
            
            Section("Filter by title") {
                TextField("Title", text: $title)
                Button("Search") {
                    filterByTitle()
                }
            }
            
            Section("Filter by date") {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                DatePicker("End date", selection: $endDate, displayedComponents: .date)
                Button("Search") {
                    filterByDate()
                }
            }
            
            
            ForEach(filteredExpenses) { expense in
                ExpenseCellView(expense: expense)
            }
            
            
            HStack {
                Spacer()
                Button("Show all") {
                    selectedTags = []
                    filteredExpenses = expenses.map { $0 }
                }
                Spacer()
            }
            
        }.padding()
            .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

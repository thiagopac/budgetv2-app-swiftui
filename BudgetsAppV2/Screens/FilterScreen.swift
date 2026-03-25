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
    @State private var selectedFilterOption: FilterOption? = nil
    
    private enum SortOptions: String, CaseIterable, Identifiable {
        case title = "title"
        case date = "dateCreated"
        
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
            rawValue
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
    
    private enum FilterOption: Identifiable, Equatable {
        case none
        case byTags(Set<Tag>)
        case byPriceRange(minPrice: Double, maxPrice: Double)
        case byTitle(String)
        case byDate(startDate: Date, endDate: Date)
        
        var id: String {
            switch self {
            case .none:
                return "none"
            case .byTags:
                return "tags"
            case .byPriceRange:
                return "priceRange"
            case .byTitle:
                return "title"
            case .byDate:
                return "date"
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
    
    private func performFilter() {
        
        guard let selectedFilterOption = selectedFilterOption else { return }
        
        let request = Expense.fetchRequest()
        
        switch selectedFilterOption {
            case .none:
                request.predicate = NSPredicate(value: true)
            case .byTags(let tags):
                let tagNames = tags.map { $0.name }
                request.predicate = NSPredicate(format: "ANY tags.name IN %@", tagNames)
            case .byDate(let startDate, let endDate):
                request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
            case .byTitle(let title):
                request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
            case .byPriceRange(let minPrice, let maxPrice):
                request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: minPrice), NSNumber(value: maxPrice))
        }
        
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
                    .onChange(of: selectedTags, {
                        selectedFilterOption = .byTags(selectedTags)
                    })
            }
            
            Section("Filter by price") {
                TextField("Start price", value: $startPrice, format: .number)
                TextField("End price", value: $endPrice, format: .number)
                Button("Search") {
                    guard let startPrice = startPrice,
                          let endPrice = endPrice else { return }
                    
                    selectedFilterOption = .byPriceRange(minPrice: startPrice, maxPrice: endPrice)
                }
            }
            
            Section("Filter by title") {
                TextField("Title", text: $title)
                Button("Search") {
                    selectedFilterOption = .byTitle(title)
                }
            }
            
            Section("Filter by date") {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                DatePicker("End date", selection: $endDate, displayedComponents: .date)
                Button("Search") {
                    
                    
                    selectedFilterOption = .byDate(startDate: startDate, endDate: endDate)
                }
            }
            
            
            ForEach(filteredExpenses) { expense in
                ExpenseCellView(expense: expense)
            }
            
            
            HStack {
                Spacer()
                Button("Show all") {
                    selectedFilterOption = FilterOption.none
                }
                Spacer()
            }
            
        }.padding()
            .navigationTitle("Filter")
            .onChange(of: selectedFilterOption, performFilter)
    }
}

#Preview {
    NavigationStack {
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

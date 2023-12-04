//
//  BookListView.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//

import SwiftUI



struct BooksListView: View {
    @ObservedObject var viewModel = BooksViewModel()

    var body: some View {
        NavigationStack {
            NavigationLink {
                AddBookView()
            } label: {
                Text("Ajouter un livre")
            }

            List(viewModel.books) { book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    HStack {
                        Text(book.title)
                        Spacer()
                        Text(book.typeTitle)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onAppear {
                viewModel.fetchBooks()
            }
        }
    }
}



#Preview {
    BooksListView()
}

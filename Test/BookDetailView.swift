//
//  BookDetailView.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book

    var body: some View {
        VStack {
            Text(book.title).font(.largeTitle)
            Text(book.typeTitle).font(.title)
        }
    }
}


#Preview {
    BookDetailView(book: Book(id: "id", title: "Titre", typeTitle: "Type"))
}

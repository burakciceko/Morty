//
//  Network.swift
//  Morty
//
//  Created by Burak Çiçek on 23.03.2022.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}

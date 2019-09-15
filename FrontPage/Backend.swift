//
//  Backend.swift
//  sui
//
//  Created by baba on 9/1/19.
//  Copyright © 2019 x. All rights reserved.
//

import SwiftUI
import Combine
import Apollo

final class Backend: ObservableObject {

  @Published var posts = [PostModel]()

  var watcher: GraphQLQueryWatcher<AllPostsQuery>?

  init() { loadData() }

  func loadData() {
    watcher = apollo.watch(query: AllPostsQuery()) { result in
      switch result {

      case .success(let graphQLResult):
        // map the result to the presentation
        self.posts = graphQLResult.data?.posts.compactMap { $0 }
                     .map { $0.fragments.postDetails }
                     .map { PostModel($0, self.upvotePost ) }
                     ?? []

      case .failure(let error):
        NSLog("Error while fetching query: \(error.localizedDescription)")
      }
    }
  }

  func upvotePost(_ id: Int) {
    apollo.perform(mutation: UpvotePostMutation(postId: id)) { result in
      switch result {
      case .success:
        break
      case .failure(let error):
        NSLog("Error while attempting to upvote post: \(error.localizedDescription)")
      }
    }
  }
}

struct PostModel: Identifiable {
  var id: Int
  var title: String
  var byLine: String
  var votes: String
  var upvote: () -> ()

  init(_ details: PostDetails, _ backendUpvote: @escaping (Int)->()) {

    id = details.id
    title = details.title ?? ""

    let fullName = [details.author?.firstName, details.author?.lastName]
        .compactMap { $0 }
        .joined(separator: " ")
    byLine = fullName.isEmpty ? "" : "by \(fullName)"

    votes = "\(details.votes ?? 0) votes"
    upvote = { backendUpvote(details.id) }
  }
}

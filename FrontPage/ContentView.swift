//
//  ContentView.swift
//  sui
//
//  Created by baba on 9/1/19.
//  Copyright © 2019 x. All rights reserved.
//

import SwiftUI
import Combine
import Apollo

struct ContentView : View {

  @ObservedObject var resource: Backend

  var body: some View {
    return List(resource.posts, rowContent: PostView.init)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(resource: Backend())
  }
}

struct PostView: View {
  var postModel: PostModel

  var body: some View {
    VStack(alignment: .leading) {
      Text(postModel.title).bold()
      HStack {
        Text(postModel.byLine)
        Text(postModel.votes)
        Button("Upvote") { self.postModel.upvote() }
      }
    }
  }
}

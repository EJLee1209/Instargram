//
//  CommentViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/04.
//

import UIKit

struct CommentViewModel {
    private let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var ownerImage: URL? {
        return URL(string: comment.ownerImageUrl)
    }
    
    var text: String {
        return self.comment.comment
    }
    
    var ownername: String {
        return comment.ownername
    }
    
}


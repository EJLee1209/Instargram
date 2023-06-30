//
//  ImageUploader.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/30.
//
import FirebaseStorage
import UIKit

struct ImageUploader {
    // 이미지를 업로드하고 escaping closure 파라미터로 이미지 다운로드 url을 전달함.
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        // UIImage를 통해 jpeg데이터를 만듬. 이미지 압축
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString // 이미지 식별값 생성
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)") // 파일 저장 경로
        
        // 이미지 업로드
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            // 이미지 다운로드 url 가져오기
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
}

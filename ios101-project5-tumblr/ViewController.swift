//
//  ViewController.swift
//  ios101-project5-tumbler
//

//import UIKit
//import Nuke
//
//class ViewController: UIViewController {
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        fetchPosts()
//    }
//
//
//
//    func fetchPosts() {
//        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
//        let session = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("❌ Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
//                print("❌ Response error: \(String(describing: response))")
//                return
//            }
//
//            guard let data = data else {
//                print("❌ Data is NIL")
//                return
//            }
//
//            do {
//                let blog = try JSONDecoder().decode(Blog.self, from: data)
//
//                DispatchQueue.main.async { [weak self] in
//
//                    let posts = blog.response.posts
//
//
//                    print("✅ We got \(posts.count) posts!")
//                    for post in posts {
//                        print("🍏 Summary: \(post.summary)")
//                    }
//                }
//
//            } catch {
//                print("❌ Error decoding JSON: \(error.localizedDescription)")
//            }
//        }
//        session.resume()
//    }
//}

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        fetchPosts()
    }
    
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    self?.posts = blog.response.posts
                    self?.tableView.reloadData()
                    
                    print("✅ We got \(self?.posts.count ?? 0) posts!")
                    for post in self?.posts ?? [] {
                        print("🍏 Summary: \(post.summary)")
                    }
                }
                
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🍏 cellForRowAt called for row: \(indexPath.row)")
        
        // Safely dequeue the cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            fatalError("❌ Failed to dequeue PostCell")
        }
        
        let post = posts[indexPath.row]
        
        // Ensure the post has at least one photo before accessing `originalSize`
        if let firstPhoto = post.photos.first {
            let imageUrl = firstPhoto.originalSize.url
            Nuke.loadImage(with: imageUrl, into: cell.PostImage)
        } else {
            print("❌ No photos available for post: \(post.summary)")
        }
        

        
        // Adjust label properties for more text display
        cell.PostButton.numberOfLines = 0  // Allow multiple lines
        cell.PostButton.lineBreakMode = .byWordWrapping  // Wrap text by word
        cell.PostButton.text = post.summary  // Set text from the post
        
        return cell
    }
}

//
// Шаблон проектирования наблюдатель
//
//

import UIKit

// MARK: - Протоколы
protocol Observable {
    func addPost(str: String)
    func changePost(str: String)
    func removeAllPosts()
    func addFollower(observer: Observer)
    func removeFolower(observer: Observer)
    func notificationForObservers()
}

protocol Observer {
    var type: String { get set }
    var name: String { get set }
    func update(post: [String])
}


// MARK: - Описание Классов
// Класс рассылающий обновления об изменении значения
final class NewsResource: Observable {
    
    private var posts: [String] = [] {
        didSet {
            notificationForObservers()
        }
    }
    
    private var observers: [Observer] = []
    
    func addPost(str: String) {
        posts.append(str)
    }
    
    func changePost(str: String){
        posts = [str]
    }
    
    func removeAllPosts(){
        posts = []
    }
    
    func addFollower(observer: Observer) {
        observers.append(observer)
    }
    
    func removeFolower(observer: Observer) {
        guard let index = observers.enumerated().first(where: { $0.element.name == observer.name })?.offset else { return }
        observers.remove(at: index)
    }
    
    func notificationForObservers() {
        observers.forEach{ $0.update(post: posts) }
    }
}

final class Reporter: Observer {
    var type = "Reporter"
    var name = "Noname"
    
    func update(post: [String]){
        print("У \(type): \(name) Новая статья в его подписках - \(post)")
    }
}


final class Blogger: Observer {
    var type = "Blogger"
    var name = "Noname"
    
    func update(post: [String]){
        print("У \(type): \(name), новая статья в его подписках - \(post)")
    }
}

// MARK: - Экземпляры
let rbkNews_Observbl = NewsResource()

let alexPerorter = Reporter()
alexPerorter.name = "Alexy"

let tonyBlogger = Blogger()
tonyBlogger.name = "Tony"

// MARK: - Call

rbkNews_Observbl.addFollower(observer: alexPerorter)
rbkNews_Observbl.addFollower(observer: tonyBlogger)

rbkNews_Observbl.addPost(str: "Good morning, we have a lot of news for you")

rbkNews_Observbl.removeFolower(observer: tonyBlogger)
rbkNews_Observbl.addPost(str: "We have just received more news")

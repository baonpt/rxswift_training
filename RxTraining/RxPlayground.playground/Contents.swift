import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

typealias JSON = [String: Any]

struct Message {
    var content: String
    
    func log() {
        print(content)
    }
}

struct Person {
    public var name: String
    public var message: BehaviorSubject<String>
    
    func send(_ message: String) {
        self.message.onNext("\(name): \(message)")
    }
}

//
// Hot & Cold Observable
//
func hotObservable() {
    // Hide keyboard when tap button
    let button = UIButton()
    let view = UIView()
    
    button.rx.tap
        .subscribe(onNext: { _ in
            view.endEditing(true)
        })
        .disposed(by: disposeBag)
    
    // Bind text from text field to label when text did change
    let textField = UITextField()
    let label = UILabel()
    
    textField.rx.text
        .orEmpty
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
}

func coldObservable() {
    guard let url = URL(string: "https://api-101.glitch.me/customers") else { return }
    let urlRequest = URLRequest(url: url)
    
    URLSession.shared.rx
        .response(request: urlRequest)
        .subscribe(onNext: { res in
            let data = res.data
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON else { return }
                print("Result: \(json)")
            } catch {
                print("error")
            }
        }, onError: { error in
            print("Error: \(error)")
        }, onCompleted: {
            print("Completed call api")
        })
        .disposed(by: disposeBag)
}

//
// Subject
//
func publishSubject() {
    let publishSubject = PublishSubject<Message>()
    publishSubject.onNext(Message(content: "Hello"))
    
    // First subscriber
    publishSubject
        .subscribe(onNext: { message in
            print("From first subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    publishSubject.onNext(Message(content: "Hiiiii"))
    
    // Second subscriber
    publishSubject
        .subscribe(onNext: { message in
            print("From second subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    publishSubject.onNext(Message(content: "How are you?"))
    publishSubject.onCompleted()
    
    // Third subscriber
    publishSubject
        .subscribe(onNext: { message in
            print("From third subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    publishSubject.onNext(Message(content: "Im fine!"))
}
// Result is
// From first subscriber:
// Hiiiii
// From first subscriber:
// How are you?
// From second subscriber:
// How are you?

func behaviorSubject() {
    let behaviorSubject = BehaviorSubject<Message>(value: Message(content: "Init message"))
    behaviorSubject.onNext(Message(content: "Hello"))
    
    // First subscriber
    behaviorSubject
        .subscribe(onNext: { message in
            print("From first subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorSubject.onNext(Message(content: "Hiiiii"))
    
    // Second subscriber
    behaviorSubject
        .subscribe(onNext: { message in
            print("From second subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorSubject.onNext(Message(content: "How are you?"))
    behaviorSubject.onCompleted()
    
    // Third subscriber
    behaviorSubject
        .subscribe(onNext: { message in
            print("From third subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorSubject.onNext(Message(content: "Im fine!"))
}
// Result is
// From first subscriber:
// Hello hi
// From first subscriber:
// Hiiiii
// From second subscriber:
// Hiiiii
// From first subscriber:
// How are you?
// From second subscriber:
// How are you?

func replaySubject() {
    let replaySubject = ReplaySubject<Message>.create(bufferSize: 2)
    replaySubject.onNext(Message(content: "Hello"))
    
    replaySubject.onNext(Message(content: "Message 1"))
    replaySubject.onNext(Message(content: "Message 2"))
    
    // First subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From first subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.onNext(Message(content: "Message 3"))
    
    // Second subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From second subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.onNext(Message(content: "Message 4"))
    replaySubject.onCompleted()
    
    // Third subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From third subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.onNext(Message(content: "Message 5"))
}
// Result is
// From first subscriber:
// Message 1
// From first subscriber:
// Message 2
// From first subscriber:
// Message 3
// From second subscriber:
// Message 2
// From second subscriber:
// Message 3
// From first subscriber:
// Message 4
// From second subscriber:
// Message 4
// From third subscriber:
// Message 3
// From third subscriber:
// Message 4

func replayRelay() {
    let replaySubject = ReplayRelay<Message>.create(bufferSize: 2)
    replaySubject.accept(Message(content: "Hello"))
    
    replaySubject.accept(Message(content: "Message 1"))
    replaySubject.accept(Message(content: "Message 2"))
    
    // First subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From first subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.accept(Message(content: "Message 3"))
    
    // Second subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From second subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.accept(Message(content: "Message 4"))
    
    // Third subscriber
    replaySubject
        .subscribe(onNext: { message in
            print("From third subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    replaySubject.accept(Message(content: "Message 5"))
}
// Result is
// From first subscriber:
// Message 1
// From first subscriber:
// Message 2
// From first subscriber:
// Message 3
// From second subscriber:
// Message 2
// From second subscriber:
// Message 3
// From first subscriber:
// Message 4
// From second subscriber:
// Message 4
// From third subscriber:
// Message 3
// From third subscriber:
// Message 4
// From first subscriber:
// Message 5
// From second subscriber:
// Message 5
// From third subscriber:
// Message 5

func behaviorRelay() {
    let behaviorRelay = BehaviorRelay<Message>(value: Message(content: "Init message"))
    
    behaviorRelay.accept(Message(content: "Message 1"))
    behaviorRelay.accept(Message(content: "Message 2"))
    
    // First subscriber
    behaviorRelay
        .asObservable()
        .subscribe(onNext: { message in
            print("From first subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorRelay.accept(Message(content: "Message 3"))
    
    // Second subscriber
    behaviorRelay
        .subscribe(onNext: { message in
            print("From second subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorRelay.accept(Message(content: "Message 4"))
    
    // Third subscriber
    behaviorRelay
        .subscribe(onNext: { message in
            print("From third subscriber:")
            message.log()
        })
        .disposed(by: disposeBag)
    
    behaviorRelay.accept(Message(content: "Message 5"))
    
    print("Current value of behavior relay: \(behaviorRelay.value.content)")
}

// Result is
// From first subscriber:
// Message 2
// From first subscriber:
// Message 3
// From second subscriber:
// Message 3
// From first subscriber:
// Message 4
// From second subscriber:
// Message 4
// From third subscriber:
// Message 4
// From first subscriber:
// Message 5
// From second subscriber:
// Message 5
// From third subscriber:
// Message 5
// Current value of behavior relay: Message 5

//
// Operator
//
///Filter

func ignoreElements() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .ignoreElements()
        .subscribe({ event in
            print(event)
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
    messageOb.onCompleted()
}
// Result is: completed, if messageOb is not onCompleted, no events will be emit

func elementAt() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .element(at: 1)
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
}
// Result is: Message 1, because messageOb consists of elements
// {Message(content: "init message"), Message(content: "Message 1"), Message(content: "Message 2"), Message(content: "Message 3")}

func filter() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .filter({ $0.content.contains("A") })
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "A: hello"))
    messageOb.onNext(Message(content: "B: Hi"))
    messageOb.onNext(Message(content: "A: How are you?"))
    messageOb.onNext(Message(content: "B: I'm fine!"))
}
// Result is
// A: hello
// A: How are you?

func skip() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .skip(2)
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
    messageOb.onNext(Message(content: "Message 4"))
    messageOb.onNext(Message(content: "Message 5"))
}
// Result is
// Message 2
// Message 3
// Message 4
// Message 5

func skipWhile() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .skip(while: { $0.content.contains("init") })
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "init 1"))
    messageOb.onNext(Message(content: "init 2"))
    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
}
// Result is
// Message 1
// Message 2
// Message 3

func skipUntil() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    let trigger = PublishSubject<Message>()
    
    messageOb
        .skip(until: trigger)
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
    
    trigger.onNext(Message(content: "start"))
    
    messageOb.onNext(Message(content: "Message 4"))
    messageOb.onNext(Message(content: "Message 5"))
}
// Result is
// Message 4
// Message 5

func take() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .take(2)
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
    messageOb.onNext(Message(content: "Message 4"))
    messageOb.onNext(Message(content: "Message 5"))
}
// Result is
// init message
// Message 1

func takeWhile() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    
    messageOb
        .take(while: { $0.content.contains("init") })
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "init 1"))
    messageOb.onNext(Message(content: "init 2"))
    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
}
// Result is
// init message
// init 1
// init 2

func takeUntil() {
    let messageOb = BehaviorSubject<Message>(value: Message(content: "init message"))
    let trigger = PublishSubject<Message>()
    
    messageOb
        .take(until: trigger)
        .subscribe(onNext: { message in
            message.log()
        })
        .disposed(by: disposeBag)

    messageOb.onNext(Message(content: "Message 1"))
    messageOb.onNext(Message(content: "Message 2"))
    messageOb.onNext(Message(content: "Message 3"))
    
    trigger.onNext(Message(content: "start"))
    
    messageOb.onNext(Message(content: "Message 4"))
    messageOb.onNext(Message(content: "Message 5"))
}
// Result is
// init message
// Message 1
// Message 2
// Message 3

/// Transform
func toArray() {
    let messageOb = Observable.of(
        Message(content: "Message 1"),
        Message(content: "Message 2"),
        Message(content: "Message 3"),
        Message(content: "Message 4")
    )
    
    messageOb
        .toArray()
        .subscribe(onSuccess: { messages in
            print(messages)
        })
        .disposed(by: disposeBag)
}

func map() {
    let messages = BehaviorRelay<Message>(value: Message(content: "Hello"))
   
    messages
        .map({ $0.content })
        .subscribe(onNext: { content in
            print(content)
        })
        .disposed(by: disposeBag)
    
    messages.accept(Message(content: "Alo 12345"))
}
// Result is
// Hello
// Alo 12345

func flatMap() {
    let personA = Person(name: "A", message: BehaviorSubject(value: "A join conversation"))
    let personB = Person(name: "B", message: BehaviorSubject(value: "B join conversation"))
    
    let conversation = PublishSubject<Person>()
    
    conversation
        .flatMap{ $0.message }
        .subscribe(onNext: { message in
            print(message)
        })
        .disposed(by: disposeBag)
    
    conversation.onNext(personA)
    conversation.onNext(personB)
    
    personA.send("Hello")
    personB.send("Hi")
    personA.send("How are you?")
    personB.send("I'm fine, and you?")
    personA.send("I'm fine, too")
    
    let personC = Person(name: "C", message: BehaviorSubject(value: "C join conversation"))
    conversation.onNext(personC)
    personC.send("Hi guys!")
}
/*
 Result is
 A join conversation
 B join conversation
 A: Hello
 B: Hi
 A: How are you?
 B: I'm fine, and you?
 A: I'm fine, too
 C join conversation
 C: Hi guys!
 */

func flatMapLatest() {
    let personA = Person(name: "A", message: BehaviorSubject(value: "A join conversation"))
    let personB = Person(name: "B", message: BehaviorSubject(value: "B join conversation"))
    
    let conversation = PublishSubject<Person>()
    
    conversation
        .flatMapLatest { $0.message }
        .subscribe(onNext: { message in
            print(message)
        })
        .disposed(by: disposeBag)
    
    conversation.onNext(personA)
    conversation.onNext(personB)
    
    personA.send("Hello")
    personB.send("Hi")
    personA.send("How are you?")
    personB.send("I'm fine, and you?")
    personA.send("I'm fine, too")
    
    let personC = Person(name: "C", message: BehaviorSubject(value: "C join conversation"))
    conversation.onNext(personC)
    personC.send("Hi guys!")
    personA.send("Goodbye")
    personB.send("Bye")
    personC.send("Bye")
}
/*
 Result is
 A join conversation
 B join conversation
 B: Hi
 B: I'm fine, and you?
 B: Bye
 C join conversation
 C: Hi guys!
 C: Bye
 */

/// Combining
struct Student {
    var score: Double
}

func concat() {
    let male = Observable.of(
        Student(score: 7),
        Student(score: 7.5),
        Student(score: 3),
        Student(score: 6),
        Student(score: 9)
    )
    
    let female = Observable.of(
        Student(score: 5),
        Student(score: 9.5),
        Student(score: 3),
        Student(score: 7.75),
        Student(score: 8)
    )
    
    Observable
        .concat(male, female)
        .subscribe(onNext: { student in
            print("Score: \(student.score)")
        })
        .disposed(by: disposeBag)

}

func merge() {
    let personA = Person(name: "A", message: BehaviorSubject(value: "A join conversation"))
    let personB = Person(name: "B", message: BehaviorSubject(value: "B join conversation"))
    
    Observable
        .of(personA.message.asObserver(), personB.message.asObserver())
        .merge()
        .subscribe(onNext: { message in
            print(message)
        })
        .disposed(by: disposeBag)
    
    personA.send("Hello")
    personB.send("Hi")
    personA.send("How are you?")
    personB.send("I'm fine, and you?")
    personA.send("I'm fine, too")
    personA.send("Goodbye")
    personB.send("Bye")
}

func combineLatest() {
    // In ViewModel
    let usernameSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    let loginSubject = PublishSubject<Void>()
    
    let account = Observable.combineLatest(usernameSubject, passwordSubject)
    
    loginSubject
        .withLatestFrom(account)
        .subscribe(onNext: { account in
            
        })
        .disposed(by: disposeBag)
    
    // In ViewController
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    
    usernameTextField.rx.text
        .map { $0 ?? "" }
        .bind(to: usernameSubject)
        .disposed(by: disposeBag)
    
    passwordTextField.rx.text
        .map { $0 ?? "" }
        .bind(to: passwordSubject)
        .disposed(by: disposeBag)
    
    loginButton.rx.tap
        .bind(to: loginSubject)
        .disposed(by: disposeBag)
}

func zip() {
    let apis = PublishSubject<String>()
    let states = PublishSubject<String>()
    
    Observable
        .zip(apis, states)
        .subscribe(onNext: { api in
            print("API: \(api.0) - state: \(api.1)")
        })
        .disposed(by: disposeBag)
    
    // Call 5 api
    apis.onNext("upload image 1")
    apis.onNext("upload image 2")
    apis.onNext("upload image 3")
    apis.onNext("upload image 4")
    apis.onNext("upload image 5")
    
    print("Upload image 1 done!")
    states.onNext("done")
    
    print("Upload image 2 done!")
    states.onNext("done")
    
    print("Upload image 3 done!")
    states.onNext("done")
    
    print("Upload image 4 done!")
    states.onNext("done")
    
    print("Upload image 5 done!")
    states.onNext("done")
}

func reduce() {
    let students = Observable.of(
        Student(score: 7),
        Student(score: 7.5),
        Student(score: 3),
        Student(score: 6),
        Student(score: 9),
        Student(score: 5),
        Student(score: 9.5),
        Student(score: 3),
        Student(score: 7.75),
        Student(score: 8)
    )
    
    students
        .reduce(0) { result, student in
            return result + student.score
        }
        .subscribe(onNext: { totalScore in
            print("Total: \(totalScore)")
        })
        .disposed(by: disposeBag)
}


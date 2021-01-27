//
//  ViewController.swift
//  RxTraining
//
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var submitButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = ViewModel()
    
    @IBAction func submitTapped(_ sender: UIButton) {
        print("Submit successfully")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        config()
    }
    
    func config() {
        let textFieldsObservable = textFields.compactMap { $0.rx.text.orEmpty.asObservable() }
        
        let input = ViewModel.Input(textFields: textFieldsObservable)
        let output = viewModel.transform(input)
        
        output
            .loginButtonEnabled
            .drive(submitButton.rx.isEnable)
            .disposed(by: disposeBag)
    }
}

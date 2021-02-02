//
//  TextFieldCell.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/2/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol TextFieldCellDelelgate {
    func textFiledDidChange(_ text: String)
}

class TextFieldCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var textFieldChangeValue = Driver.just("")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension TextFieldCell {
    func bind<T>(to viewModel: TextFieldCellViewModel, textDidChange: T) where T: ObserverType, T.Element == String {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.text
            .drive(inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        inputTextField.rx
            .text
            .orEmpty
            .bind(to: textDidChange)
            .disposed(by: disposeBag)
    }
}

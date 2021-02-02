//
//  StyleCheckBoxCell.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/1/21.
//

import UIKit
import BEMCheckBox
import RxSwift
import RxCocoa

class CheckBoxCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var checkBoxView: BEMCheckBox!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBoxView.boxType = .square
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension CheckBoxCell {
    func bind(to viewModel: CheckBoxCellViewModel) {
        viewModel.name
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.imageURL
            .drive(rightImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        viewModel.isSelected
            .drive(checkBoxView.rx.isOn)
            .disposed(by: disposeBag)
    }
}

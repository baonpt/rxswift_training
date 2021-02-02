//
//  SectionHeaderCell.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/1/21.
//

import UIKit
import RxCocoa
import RxSwift

class SectionHeaderCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        makeUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension SectionHeaderCell {
    func makeUI() {
        numberLabel.corner()
    }
    
    func bind(to viewModel: SectionHeaderCellViewModel) {
        viewModel.number
            .drive(numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

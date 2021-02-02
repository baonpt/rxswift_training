//
//  CheckBox+.swift
//  RxTraining
//
//

import Foundation
import BEMCheckBox

extension BEMCheckBox {
    
    func setOn(_ isOn: Bool) {
        let setOn = {
            self.setOn(true, animated: true)
            self.onTintColor = UIColor.init(hex: "469be1")
            self.onFillColor = UIColor.init(hex: "469be1")
            self.onCheckColor = .white
        }
        
        let setOff = {
            self.setOn(false, animated: true)
            self.offFillColor = .white
        }
        
        if isOn {
            setOn()
        } else {
            setOff()
        }
    }
    
    func toggle() {
        self.setOn(!self.on)
    }
}

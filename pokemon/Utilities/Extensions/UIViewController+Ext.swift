//
//  UIViewController+Ext.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

import UIKit

// MARK: - Manage Loading
extension UIViewController {
    func manageLoadingActivity(isLoading: Bool) {
        if isLoading {
            showLoadingActivity()
        } else {
            hideLoadingActivity()
        }
    }
    
    func showLoadingActivity() {
        self.view.makeToastActivity(.center)
    }
    
    func hideLoadingActivity() {
        self.view.hideToastActivity()
    }
}

// MARK: - Get Image
extension UIViewController {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}

// MARK: - Manage TTGSnackbar
var snackBarExt: TTGSnackbar?
extension UIViewController {
    func showErrorSnackBar(message: String?) {
        guard let errorMessage = message else { return }
        snackBarExt?.dismiss()
        snackBarExt = TTGSnackbar(message: errorMessage, duration: .short)
        snackBarExt?.duration = .middle
        snackBarExt?.shouldDismissOnSwipe = true
        snackBarExt?.backgroundColor = .red
        snackBarExt?.actionTextNumberOfLines = 0
        snackBarExt?.show()
    }
    
    func showSuccessSnackBar(message: String?) {
        guard let successMessage = message else { return }
        snackBarExt?.dismiss()
        snackBarExt = TTGSnackbar(message: successMessage, duration: .short)
        snackBarExt?.duration = .middle
        snackBarExt?.shouldDismissOnSwipe = true
        snackBarExt?.backgroundColor = .green
        snackBarExt?.actionTextNumberOfLines = 0
        snackBarExt?.show()
    }
}

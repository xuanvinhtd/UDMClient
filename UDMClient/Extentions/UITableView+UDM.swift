//
//  UITableView+UDM.swift
//  UDMTeacher
//
//  Created by OSXVN on 12/24/16.
//  Copyright © 2016 XUANVINHTD. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(Self) }
    static var nib: UINib? { return nil }
}

extension UITableView {
    func registerReusableCell<T: UITableViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>() -> T? {
        return self.dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T?
    }
}

extension UICollectionView {
    func registerReusableCell<T: UICollectionViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithReuseIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    func registerReusableSupplementaryView<T: Reusable>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionViewCell where T: Reusable>(elementKind: String, indexPath: NSIndexPath) -> T {
        return self.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
}

// Usage
/*
class CodeBasedCustomCell: UITableViewCell, Reusable {
    // By default this cell will have a reuseIdentifier or "MyCustomCell"
    // unless you provide an alternative implementation of `var reuseIdentifier`
    // ...
}

class NibBasedCustomCell: UITableViewCell, Reusable {
    // Here we provide a nib for this cell class
    // (instead of relying of the protocol's default implementation)
    static var nib: UINib? {
        return UINib(nibName: String(NibBasedCustomCell.self), bundle: nil)
    }
    // ...
}

class MyTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(CodeBasedCustomCell.self) // This will register using the class without using a UINib
        tableView.registerReusableCell(NibBasedCustomCell.self) // This will register using NibBasedCustomCell.xib
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(indexPath: indexPath) as CodeBasedCustomCell
        } else {
            cell = tableView.dequeueReusableCell(indexPath: indexPath) as NibBasedCustomCell
        }
        return cell
    }
} */
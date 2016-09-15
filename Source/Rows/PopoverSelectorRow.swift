//  PopoverSelectorRow.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public class _PopoverSelectorRow<T: Equatable, Cell: CellType where Cell: BaseCell, Cell: TypedCellType, Cell.Value == T> : SelectorRow<T, Cell, SelectorViewController<T>> {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        onPresentCallback = { [weak self] (_, viewController) -> Void in
            guard let porpoverController = viewController.popoverPresentationController, tableView = self?.baseCell.formViewController()?.tableView, cell = self?.cell else {
                fatalError()
            }
            porpoverController.sourceView = tableView
            porpoverController.sourceRect = tableView.convertRect(cell.detailTextLabel?.frame ?? cell.textLabel?.frame ?? cell.contentView.frame, fromView: cell)
        }
        presentationMode = .Popover(controllerProvider: ControllerProvider.Callback { return SelectorViewController<T>(){ _ in } }, completionCallback: { [weak self] in
            $0.dismissViewControllerAnimated(true, completion: nil)
            self?.reload()
            })
    }
    
    public override func didSelect() {
        deselect()
        super.didSelect()
    }
}

public final class PopoverSelectorRow<T: Equatable> : _PopoverSelectorRow<T, PushSelectorCell<T>>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

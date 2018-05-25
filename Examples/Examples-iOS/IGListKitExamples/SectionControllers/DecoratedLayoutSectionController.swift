//
//  DecoratedLayoutSectionController.swift
//  IGListKitExamples
//
//  Created by Jonathan Tamboer on 5/24/18.
//

import IGListKit
import UIKit

final class DecoratedLayoutSectionController: ListSectionController {

    static let spacing: CGFloat = 4
    private var model: SelectionModel!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        minimumLineSpacing = DecoratedLayoutSectionController.spacing
        minimumInteritemSpacing = DecoratedLayoutSectionController.spacing
    }

    override func numberOfItems() -> Int {
        return model.options.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let text = model.options[index]
        let width = collectionContext!.containerSize.width
        let height = DecoratedLayoutCell.textHeight(text, width: width)
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: DecoratedLayoutCell.self, for: self, at: index) as? DecoratedLayoutCell else {
            fatalError()
        }
        cell.text = model.options[index]
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = object as? SelectionModel
    }

}

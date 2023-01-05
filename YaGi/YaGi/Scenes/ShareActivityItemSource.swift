//
//  ShareActivityItemSource.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/12/06.
//

import LinkPresentation

class ShareActivityItemSource:  NSObject, UIActivityItemSource {
    var title: String
    var content: String
    var placeholder: String
    
    init(title: String, content: String, placeholder: String) {
        self.title = title
        self.content = content
        self.placeholder = placeholder
        
        super.init()
    }
    
    //Returns the placeholder object for the data.
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return placeholder
    }
    
    //Returns the data object to be acted upon.
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return content
    }
    
    //For activities that support a subject field, returns the subject for the item.
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    //Returns metadata to display in the preview header of the share sheet.
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        // TODO: - Change to AppIcon
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "text.bubble")!)
        metadata.originalURL = URL(fileURLWithPath: placeholder )
        
        return metadata
    }
}

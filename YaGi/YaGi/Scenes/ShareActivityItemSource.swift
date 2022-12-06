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
    //데이터에 대한 미리보기 반환
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return placeholder
    }
    
    //Returns the data object to be acted upon.
    //행동 될 데이터 객체 반환
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return content
    }
    
    //For activities that support a subject field, returns the subject for the item.
    //제목 필드를 지원하는 액티비티에 대해, 아이템에 대한 제목을 반환
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    //Returns metadata to display in the preview header of the share sheet.
    //share sheet의 헤더에 미리보기로 보여줄 메타데이터를 반환한다.
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        // TODO: - Change to AppIcon
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "text.bubble")!)
        //This is a bit ugly, though I could not find other ways to show text content below title.
        //https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
        //You may need to escape some special characters like "/".
        metadata.originalURL = URL(fileURLWithPath: placeholder )
        return metadata
    }
}

//
//  CourseOutlineHeaderViewTests.swift
//  edX
//
//  Created by Akiva Leffert on 6/3/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import edX
import Foundation

class CourseOutlineHeaderViewTests : SnapshotTestCase {
    
    func testDownloadProgressView() {
        let downloadProgressView = CourseOutlineHeaderView(frame: CGRectZero, styles: OEXStyles(), titleText: OEXLocalizedString("VIDEO_DOWNLOADS_IN_PROGRESS", nil), shouldShowSpinner: true)
        
        let size = downloadProgressView.systemLayoutSizeFittingSize(self.screenSize)
        downloadProgressView.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        downloadProgressView.layoutIfNeeded()
        assertSnapshotValidWithContent(downloadProgressView)
    }
    
    func testHeaderInfoView() {
        let headerInfoView = CourseOutlineHeaderView(frame: CGRectZero, styles: OEXStyles(), titleText: OEXLocalizedString("LAST_ACCESSED", nil), subtitleText : "This is a very long subtitle which should not overlap the button")
        
        let size = headerInfoView.systemLayoutSizeFittingSize(self.screenSize)
        // Using 380 to make sure that the subtitle truncates
        headerInfoView.bounds = CGRect(x: 0, y: 0, width: 380, height: size.height)
        
        headerInfoView.layoutIfNeeded()
        assertSnapshotValidWithContent(headerInfoView)

    }
}
//
//  CourseDashboardViewController.swift
//  edX
//
//  Created by Ehmad Zubair Chughtai on 11/05/2015.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit

public class CourseDashboardViewControllerEnvironment : NSObject {
    let config: OEXConfig?
    weak var router: OEXRouter?
    let networkManager : NetworkManager?
    
    public init(config: OEXConfig?, router: OEXRouter?, networkManager: NetworkManager?) {
        self.config = config
        self.router = router
        self.networkManager = networkManager
    }
}

struct CourseDashboardItem {
    let title: String
    let detail: String
    let icon : Icon
    let action:(() -> Void)
}

public class CourseDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    private let headerHeight = 180

    private let environment: CourseDashboardViewControllerEnvironment!
    private var course: OEXCourse?
    
    private var tableView: UITableView = UITableView()
    
    private var cellItems: [CourseDashboardItem] = []
    
    public init(environment: CourseDashboardViewControllerEnvironment, course: OEXCourse?) {
        self.environment = environment
        self.course = course
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = course?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        // required by the compiler because UIViewController implements NSCoding,
        // but we don't actually want to serialize these things
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = OEXStyles.sharedStyles().neutralXLight()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { make -> Void in
            make.edges.equalTo(self.view)
        }
        
        let courseView = CourseDashboardCourseInfoView(frame: CGRect(x : 0, y: 0, width: 0, height : headerHeight))
        if let course = self.course {
            courseView.titleText = course.name
            courseView.detailText = (course.org ?? "") + (course.number.map { " | " + $0 } ?? "")
            
            //TODO: the way to load image is not perfect, need to do refactoring later
            courseView.course = course
            courseView.setCoverImage()
        }
        tableView.tableHeaderView = courseView
        
        // Register tableViewCell
        tableView.registerClass(CourseDashboardCell.self, forCellReuseIdentifier: CourseDashboardCell.identifier)
        
        prepareTableViewData()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public func prepareTableViewData() {
        var item = CourseDashboardItem(title: OEXLocalizedString("COURSE_DASHBOARD_COURSEWARE", nil), detail: OEXLocalizedString("COURSE_DASHBOARD_COURSE_DETAIL", nil), icon : .Courseware) {[weak self] () -> Void in
            self?.showCourseware()
        }
        cellItems.append(item)
        if let courseID = course?.course_id where shouldEnableDiscussions() {
            item = CourseDashboardItem(title: OEXLocalizedString("COURSE_DASHBOARD_DISCUSSION", nil), detail: OEXLocalizedString("COURSE_DASHBOARD_DISCUSSION_DETAIL", nil), icon: .Discussions) {[weak self] () -> Void in
                self?.showDiscussionsForCourseID(courseID)
            }
            cellItems.append(item)
        }
        item = CourseDashboardItem(title: OEXLocalizedString("COURSE_DASHBOARD_HANDOUTS", nil), detail: OEXLocalizedString("COURSE_DASHBOARD_HANDOUTS_DETAIL", nil), icon: .Handouts) {[weak self] () -> Void in
            self?.showHandouts()
        }
        cellItems.append(item)
        item = CourseDashboardItem(title: OEXLocalizedString("COURSE_DASHBOARD_ANNOUNCEMENTS", nil), detail: OEXLocalizedString("COURSE_DASHBOARD_ANNOUNCEMENTS_DETAIL", nil), icon: .Announcements) {[weak self] () -> Void in
            self?.showAnnouncements()
        }
        cellItems.append(item)
    }
    
    
    func shouldEnableDiscussions() -> Bool {
        return self.environment.config!.shouldEnableDiscussions()
    }
    
    
    // MARK: - TableView Data and Delegate
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CourseDashboardCell.identifier, forIndexPath: indexPath) as! CourseDashboardCell
        
        let dashboardItem = cellItems[indexPath.row]
        cell.useItem(dashboardItem)
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dashboardItem = cellItems[indexPath.row]
        dashboardItem.action()
    }
    
    func showCourseware() {
        if let course = self.course, courseID = course.course_id {
            self.environment.router?.showCoursewareForCourseWithID(courseID, fromController: self)
        }
    }
    
    func showDiscussionsForCourseID(courseID: String) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.environment.router?.showDiscussionTopicsFromController(self, courseID: courseID)
    }
    
    func showHandouts() {
            self.environment.router?.showHandouts(self.course?.course_handouts, fromViewController: self)
    }
    
    func showAnnouncements() {
        self.environment.router?.showAnnouncementsForCourseWithID(course?.course_id)
    }
}

// MARK: Testing
extension CourseDashboardViewController {
    
    public func t_canVisitDiscussions() -> Bool {
        if self.cellItems.count == 4 {
            return true
        }
        return false
    }
    
}


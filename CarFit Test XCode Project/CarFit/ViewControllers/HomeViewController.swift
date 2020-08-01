//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    // MARK: - IBOutlets
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarViewTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    // MARK: - Variables/Constants
    
    private let animationDuration: TimeInterval = 0.4
    private let calendarViewHeight: CGFloat = 200
    private let tableViewTopWithCalendar: CGFloat = 124
    private let tableViewTopWithoutCalendar: CGFloat = 12
    
    let refreshControl = UIRefreshControl()
    private var calendarComponent: CalendarView? = nil
    
    lazy var viewModel: CleanerListViewModel = {
        return CleanerListViewModel()
    }()
    
    // MARK: - Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
        updateUIForSelectedDate(date: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Hide calendar view if user taps anywhere outside of the calendar
        if let touch = touches.first {
            let location = touch.location(in: workOrderTableView)
            if workOrderTableView.bounds.contains(location) {
                showCalendar(show: false)
            }
        }
    }
    
    // MARK:- Add calender to view
    
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            // To disable auto selection of today's date, uncomment the below line
            //calendar.autoSelectTodayOnMonthChanged = false
            calendar.delegate = self
            calendarComponent = calendar
        }
    }

    // MARK:- UI setups

    private func setupUI() {
        navBar.transparentNavigationBar()
        workOrderTableView.register(cell: HomeTableViewCell.self)
        workOrderTableView.rowHeight = UITableView.automaticDimension
        workOrderTableView.estimatedRowHeight = 170
        
        // Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshCarwashes), for: .valueChanged)
        workOrderTableView.addSubview(refreshControl)
        
        // The initial state of the calendar view as hidden.
        // Also, we do not want the user to see the animation while hiding the calendar view.
        showCalendar(show: false, animated: false)
    }
    
    @objc private func refreshCarwashes() {
        // Using delay here just for the feel of refreshing the data from some remote server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let calendar = self.calendarComponent {
                self.updateUIForSelectedDate(date: calendar.selectedDate)
            }
        }
    }
    
    private func updateUIForSelectedDate(date: Date) {
        // Update the title of the screen
        if let item = navBar.items?.first {
            item.title = date.isToday ? today : date.dateInYMD
        }

        // Get CarFitVisits for the selected date
        viewModel.getCarWashes(for: date) { (success, error) in
            self.refreshControl.endRefreshing()
            self.workOrderTableView.reloadData()
            if !success {
                self.displayAlert(with: "", message: error ?? genericError, actions: [UIAlertAction(title: okay, style: .default, handler: nil)])
            }
        }
    }
    
    // MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        showCalendar(show: true)
    }
    
    private func showCalendar(show: Bool, animated: Bool = true) {
        // Hide without animation
        if !animated {
            updateCalendarViewConstraints(showCalendar: show)
            return // We use return here as we don't want the below code to be executed.
        }
        
        // Hide/Show calendar view with animation
        UIView.animate(withDuration: animationDuration) {
            self.updateCalendarViewConstraints(showCalendar: show)
        }
    }
    
    private func updateCalendarViewConstraints(showCalendar: Bool) {
        // The calendar is supposed to be shown when tapped on the calendar buttton and hidden when tapped anywhere outside the calendat view.
        // To hide and show the calendar view, we are changing the calendar view's top constraint.
        // To keep the spacing above the tableview consistent, we also need to change the tableview's top constraint value accordingly.
        calendarViewTop.constant = showCalendar ? 0 : -calendarViewHeight
        tableViewTop.constant = showCalendar ? tableViewTopWithCalendar : tableViewTopWithoutCalendar
        view.layoutIfNeeded()
        
        // To dismiss/hide the calendarView when the user touches out side the calendar, disable interaction on our workOrderTableView.
        // Disabling interaction on the table view will call touchesBegan() method of the view controller whenever user interatact/touches the screen.
        workOrderTableView.isUserInteractionEnabled = !showCalendar
    }
    
}


// MARK:- Tableview delegate and datasource methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCarwashes()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: HomeTableViewCell.self)!
        cell.display(visit: viewModel.carwash(for: indexPath), previousVisit: viewModel.previousCarwash(indexPath: indexPath))
        return cell
    }
    
}

// MARK:- Get selected calendar date

extension HomeViewController: CalendarDelegate {
    
    func monthChanged(calendarView: CalendarView, currentMonth: Date) {
        // If user arrives on the current month, select today's date.
        // The code below is commented as this functionality is already handled inside the calendar view.
        // The reason to keep this code is to show that this can also be achieved from outside of the calendar view.
        // If we don't want the calendar to do this, set the property autoSelectTodayOnmonthChange to false on calendarView.
        /*if currentMonth.isInThisMonth {
            calendarView.select(date: Date())
            updateUIForSelectedDate(date: calendarView.selectedDate)
        }*/
    }
    
    func didSelectDate(calendarView: CalendarView, selectedDate: Date) {
        updateUIForSelectedDate(date: selectedDate)
    }
    
}

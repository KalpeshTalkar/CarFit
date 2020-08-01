//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

// Markin @objc to add support for optional protocols
@objc protocol CalendarDelegate: class {
    
    /// Called when the month is changed.
    /// - Parameters:
    ///   - calendarView: CalendarView instance.
    ///   - currentMonth: Curent month shown in the calendar. This is different from the selectedDate.
    @objc optional func monthChanged(calendarView: CalendarView, currentMonth: Date)
    
    
    /// Called when a date is selected.
    /// - Parameters:
    ///   - calendarView: CalendarView instance.
    ///   - selectedDate: Selected date in the calendar view.
    @objc optional func didSelectDate(calendarView: CalendarView, selectedDate: Date)
}

class CalendarView: UIView {

    // MARK: - IBActions
    
    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    
    /// If the calendar should auto select today's date when arriving on today's month, set to true else false. By defualt the value is true.
    var autoSelectTodayOnMonthChanged = true
    
    private let calendar = Calendar(identifier: .gregorian)
    weak var delegate: CalendarDelegate?
    
    private lazy var viewModel: CalendarViewModel = {
        return CalendarViewModel()
    }()
    
    var selectedDate: Date {
        return viewModel.selectedDate
    }

    // MARK:- Initialize calendar
    
    private func initialize() {
        // Show current month and year on the calendar view
        monthAndYear.text = viewModel.getCurrentMonthAndYear()
        
        // Setup collection view
        daysCollectionView.register(cell: DayCell.self)
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        
        // Show selected date
        scrollToSelectedDate()
    }
    
    private func scrollToSelectedDate() {
        if let indexPath = viewModel.indexPathForSelectedDate() {
            daysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK:- Change month when left and right arrow button tapped
    
    @IBAction func arrowTapped(_ sender: UIButton) {
        // Check the sender to show previous or next month.
        // The action is called only by the leftBtn and rightBtn only.
        // If the action had multiple senders other than leftBtn and rightBtn,
        // then to restrict the code for these buttons only, we can use the below condition
        if sender != leftBtn && sender != rightBtn {
            return
        }
        // If leftBtn is clicked, we need to show the preivious month else show the next month.
        sender == leftBtn ? viewModel.previousMonth() : viewModel.nextMonth()
        
        // Select the today's date automatically if the month is current.
        if viewModel.currentMonth.isInThisMonth && autoSelectTodayOnMonthChanged {
            viewModel.selectedDate = Date()
            // Notify the delegate
            delegate?.didSelectDate?(calendarView: self, selectedDate: viewModel.selectedDate)
        }
        
        // Reload our UI and collection view to show the new moth and it's days
        monthAndYear.text = viewModel.getCurrentMonthAndYear()
        daysCollectionView.reloadData()
        
        if viewModel.selectedDate.isInSameMonth(date: viewModel.currentMonth) {
            scrollToSelectedDate()
        } else {
            daysCollectionView.scrollToLeft(animated: true)
        }
        
        // Call the delegate
        delegate?.monthChanged?(calendarView: self, currentMonth: viewModel.currentMonth)
    }
    
    func select(date: Date) {
        viewModel.selectedDate = date
        scrollToSelectedDate()
    }
    
}

// MARK:- Calendar collection view delegate and datasource methods

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfDaysInCurrentMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, ofType: DayCell.self)!
        let date = viewModel.date(for: indexPath)
        cell.show(date: date, selected: viewModel.isSelected(date: date))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Below condition prevents fetching car washes again for already selected date.
        // To refresh the current list of car washes, we already have pull to refresh implemented using UIRefreshControl.
        let date = viewModel.date(for: indexPath)
        if viewModel.selectedDate.compare(date) == .orderedSame {
            return
        }
        
        // Update selected date
        // We are not relying on collection view's didSelectItemAt(indexPath) and didDeselectItemAt(indexPath)
        // We want our view model to hold all the states and values of our UI
        // So we maintain the selectedDate in our view model.
        viewModel.selectedDate = date
        
        // Update selection
        // We can perform reload here as this operation is not going to be heavy as it's only finite labels are rendered.
        // For better performance we cam update only the visible cells and new cells on scrolling will be having updated state.
        // If the prefetch is enabled, updating visible cells won't work as there are more cells loaded than we see in the UI.
        // So in our case we can perfrom reloadData() or disable prefetch and reload only visible cells.
        collectionView.reloadData()
        
        // Notify the delegate
        delegate?.didSelectDate?(calendarView: self, selectedDate: viewModel.date(for: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
}

// MARK:- Add calendar to the view

extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}

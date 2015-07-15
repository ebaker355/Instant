//: Playground - noun: a place where people can play

import Foundation

func dateString(date: NSDate?) -> String {
    guard let date = date else { return "nil date" }

    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    formatter.timeStyle = .FullStyle

    return formatter.stringFromDate(date)
}

struct DateComponents : Comparable, Equatable {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int

    init() {
        self.init(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0)
    }

    init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }

    init(hour: Int, minute: Int, second: Int) {
        self.init(year: 0, month: 0, day: 0, hour: hour, minute: minute, second: second)
    }

    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    init(components: NSDateComponents) {
        self.init(year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second)
    }
}

extension NSDateComponents {
    convenience init(_ components: DateComponents) {
        self.init()

        year = components.year
        month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = components.second
    }
}

extension NSCalendar {
    func componentsFromDate(date: NSDate) -> DateComponents {
        return DateComponents(components: self.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date))
    }

    func dateFromComponents(comps: DateComponents) -> NSDate? {
        return self.dateFromComponents(NSDateComponents(comps))
    }

    func dateByAddingComponents(comps: DateComponents, toDate date: NSDate, options opts: NSCalendarOptions) -> NSDate? {
        return self.dateByAddingComponents(NSDateComponents(comps), toDate: date, options: opts)
    }
}

extension IntegerType {
    var years: DateComponents { get { return DateComponents(year: self as! Int, month: 0, day: 0) } }
    var year: DateComponents { get { return self.years } }

    var months: DateComponents { get { return DateComponents(year: 0, month: self as! Int, day: 0) } }
    var month: DateComponents { get { return self.months } }

    var days: DateComponents { get { return DateComponents(year: 0, month: 0, day: self as! Int) } }
    var day: DateComponents { get { return self.days } }

    var hours: DateComponents { get { return DateComponents(hour: self as! Int, minute: 0, second: 0) } }
    var hour: DateComponents { get { return self.hours } }

    var minutes: DateComponents { get { return DateComponents(hour: 0, minute: self as! Int, second: 0) } }
    var minute: DateComponents { get { return self.minutes } }

    var seconds: DateComponents { get { return DateComponents(hour: 0, minute: 0, second: self as! Int) } }
    var second: DateComponents { get { return self.seconds } }
}

func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
    guard lhs != rhs else { return false }
    guard
        let lhsDate = NSCalendar.currentCalendar().dateFromComponents(lhs),
        let rhsDate = NSCalendar.currentCalendar().dateFromComponents(rhs) else { return false }

    return lhsDate.compare(rhsDate) == NSComparisonResult.OrderedAscending
}

func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
    guard
        let lhsDate = NSCalendar.currentCalendar().dateFromComponents(lhs),
        let rhsDate = NSCalendar.currentCalendar().dateFromComponents(rhs) else { return false }

    return lhsDate.compare(rhsDate) == NSComparisonResult.OrderedSame
}

func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
    return DateComponents(year: lhs.year + rhs.year,
        month: lhs.month + rhs.month,
        day: lhs.day + rhs.day,
        hour: lhs.hour + rhs.hour,
        minute: lhs.minute + rhs.minute,
        second: lhs.second + rhs.second)
}

func += (inout lhs: DateComponents, rhs: DateComponents) {
    lhs = lhs + rhs
}

func + (lhs: NSDate?, rhs: DateComponents) -> NSDate? {
    guard let date = lhs else { return lhs }
    return NSCalendar.currentCalendar().dateByAddingComponents(rhs, toDate: date, options: NSCalendarOptions(rawValue: 0))
}

func += (inout lhs: NSDate?, rhs: DateComponents) {
    guard let date = lhs else { return }
    lhs = NSCalendar.currentCalendar().dateByAddingComponents(rhs, toDate: date, options: NSCalendarOptions(rawValue: 0))
}

func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
    return DateComponents(year: lhs.year - rhs.year,
        month: lhs.month - rhs.month,
        day: lhs.day - rhs.day,
        hour: lhs.hour - rhs.hour,
        minute: lhs.minute - rhs.minute,
        second: lhs.second - rhs.second)
}

func -= (inout lhs: DateComponents, rhs: DateComponents) {
    lhs = lhs - rhs
}

func -= (inout lhs: NSDate?, rhs: DateComponents) {
    guard let date = lhs else { return }

    let comps = NSCalendar.currentCalendar().componentsFromDate(date)
    lhs = NSCalendar.currentCalendar().dateFromComponents(comps - rhs)
}

var c1 = DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 70)
var c2 = DateComponents(year: 0, month: 0, day: 0, hour: 0, minute: 2, second: 10)

c1 == c2
c1 != c2
c1 > c2
c1 < c2

let c3 = c1 + c2
c3.year

1.year < 2.years
3.years < 2.years
5.years == 5.years

(1.minute + 10.seconds) == 70.seconds

var a = 1.second
a += 3.seconds
a.second

a -= 2.seconds
a.second


var date = NSCalendar.currentCalendar().dateFromComponents(DateComponents(year: 2015, month: 7, day: 15))
print(dateString(date))

//date += 3.days + 5.minutes

//date += (-3).days

date -= 1.day + 5.minutes

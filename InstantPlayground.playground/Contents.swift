//: Playground - noun: a place where people can play

import Foundation

func dateString(date: NSDate?) -> String {
    guard let date = date else { return "nil date" }

    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    formatter.timeStyle = .FullStyle

    return formatter.stringFromDate(date)
}

func calendarUnitAsString(unit: NSCalendarUnit) -> String {
    switch unit {
    case NSCalendarUnit.Year:
        return "year"

    case NSCalendarUnit.Month:
        return "month"

    case NSCalendarUnit.Day:
        return "day"

    case NSCalendarUnit.Hour:
        return "hour"

    case NSCalendarUnit.Minute:
        return "minute"

    case NSCalendarUnit.Second:
        return "second"

    default:
        return "other"
    }
}

//------------------------------------------------------------------------------
// NSCalendar Extension
//------------------------------------------------------------------------------

extension NSCalendar {

    private var referenceDate: NSDate { get {
//        return NSDate.distantPast() as NSDate
        let comps = NSDateComponents()
        comps.year = 1970
        comps.month = 1
        comps.day = 1
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(comps)!
    } }

    internal func dateWithSpanFromReferenceDate<T: IntegerType>(span: CalendarUnitSpan<T>) -> NSDate? {
        return self.dateByAddingComponents(span.dateComponents, toDate: referenceDate, options: NSCalendarOptions(rawValue: 0))
    }
}



//------------------------------------------------------------------------------
// Calendar Unit Span
//------------------------------------------------------------------------------

struct CalendarUnitSpan<T: IntegerType> : Equatable, Comparable {
    var span: T
    var unit: NSCalendarUnit

    var dateComponents: NSDateComponents { get {
        guard let span = span as? Int where span != 0 else { return NSDateComponents() }

        let comps = NSDateComponents()

        switch unit {

        case NSCalendarUnit.Second:
            comps.second = span

        case NSCalendarUnit.Minute:
            comps.minute = span

        case NSCalendarUnit.Hour:
            comps.hour = span

        case NSCalendarUnit.Day:
            comps.day = span

        case NSCalendarUnit.Month:
            comps.month = span

        case NSCalendarUnit.Year:
            comps.year = span

        default:
            break
        }

        return comps
    }}

    // This method is just for testing.
    func description() -> String {
        var unitName = calendarUnitAsString(unit)
        if (span as! Int) != 1 {
            unitName += "s"
        }
        return "\(span) \(unitName)"
    }
}

// Equatable
func == <T: IntegerType>(lhs: CalendarUnitSpan<T>, rhs: CalendarUnitSpan<T>) -> Bool {
    // Try simple check of values first.
    if lhs.span == rhs.span && lhs.unit.rawValue == rhs.unit.rawValue {
        return true
    }

    // Do date math to check for equality.
    guard
        let lhsDate = NSCalendar.currentCalendar().dateWithSpanFromReferenceDate(lhs),
        let rhsDate = NSCalendar.currentCalendar().dateWithSpanFromReferenceDate(rhs)
    else { return false }

    return lhsDate.isEqualToDate(rhsDate)
}

// Comparable
func < <T:IntegerType>(lhs: CalendarUnitSpan<T>, rhs: CalendarUnitSpan<T>) -> Bool {
    // Eliminate equality to adhere to strict total order
    if lhs == rhs {
        return false
    }

    // Try simple check of values first.
    if lhs.span < rhs.span && lhs.unit.rawValue <= rhs.unit.rawValue {
        return true
    }

    // Do date math to check for equality.
    guard
        let lhsDate = NSCalendar.currentCalendar().dateWithSpanFromReferenceDate(lhs),
        let rhsDate = NSCalendar.currentCalendar().dateWithSpanFromReferenceDate(rhs)
    else { return false }

    return lhsDate.compare(rhsDate) == .OrderedAscending
}



//------------------------------------------------------------------------------
// IntegerType Extension
//------------------------------------------------------------------------------

extension IntegerType {
    var second: CalendarUnitSpan<Self> { get { return seconds } }
    var seconds: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Second) } }

    var minute: CalendarUnitSpan<Self> { get { return minutes } }
    var minutes: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Minute) } }

    var hour: CalendarUnitSpan<Self> { get { return hours } }
    var hours: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Hour) } }

    var day: CalendarUnitSpan<Self> { get { return days } }
    var days: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Day) } }

    var month: CalendarUnitSpan<Self> { get { return months } }
    var months: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Month) } }

    var year: CalendarUnitSpan<Self> { get { return years } }
    var years: CalendarUnitSpan<Self> { get { return CalendarUnitSpan(span: self, unit: .Year) } }
}



//------------------------------------------------------------------------------
// NSDate operations
//------------------------------------------------------------------------------

func + <T: IntegerType>(lhs: NSDate?, rhs: CalendarUnitSpan<T>) -> NSDate? {
    guard let lhs = lhs else { return nil }

    return NSCalendar.currentCalendar().dateByAddingComponents(rhs.dateComponents, toDate: lhs, options: NSCalendarOptions(rawValue: 0))
}

func += <T: IntegerType>(lhs: NSDate?, rhs: CalendarUnitSpan<T>) -> NSDate? {
    return lhs + rhs
}



//------------------------------------------------------------------------------
// Operation Tests
//------------------------------------------------------------------------------

let date = NSDate()
print(dateString(date))

var future = date + 30.seconds
print(dateString(future))

future = future + 5.minutes
print(dateString(future))

future += 1.hour
print(dateString(future))

future += 5.days
print(dateString(future))

future += 5.months
print(dateString(future))

future = future + 5.years
print(dateString(future))

future = ((future + 3.years) + 1.minute) + 2.months
print(dateString(future))


//------------------------------------------------------------------------------
// Equality Tests
//------------------------------------------------------------------------------

1.year == 1.year
1.year == 365.days
1.month == 31.days
1.hour == 60.minutes
1.minute == 60.seconds
1.day == 24.hours
1440.minutes == 1.day
2880.minutes == 2.days



//------------------------------------------------------------------------------
// Comparable Tests
//------------------------------------------------------------------------------

1.year < 2.years
2.years < 1.year
11.months < 1.year
11.months < 10.months
10.months < 11.months
11.months > 10.months
10.months > 11.months
59.seconds < 1.minute
2.minutes >= 120.seconds
60.minutes >= 1.hour



print("still good")

//
//  MoonTimes.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 7/16/19.
//

import Foundation

public struct MoonTimes {
    public enum Horizon {
        case riseAndSets
        case alwaysAbove
        case alwaysBelow
    }

    public var rise: Date?
    public var set: Date?
    public var horizon: Horizon

    init(date: Date, latitude: Double, longitude: Double) {
        let hc: Double = 0.133 * Double.rad
        let moonPosition = MoonPosition(date: date, latitude: latitude, longitude: longitude)

        var h0: Double = moonPosition.altitude - hc
        var h1: Double = 0
        var h2: Double = 0
        var rise: Double = 0
        var set: Double = 0
        var a: Double = 0
        var b: Double = 0
        var xe: Double = 0
        var ye: Double = 0
        var d: Double = 0
        var roots: Double = 0
        var x1: Double = 0
        var x2: Double = 0
        var dx: Double = 0

        // go in 2-hour chunks, each time seeing if a 3-point quadratic curve crosses zero (which means rise or set)
        for i in stride(from: 1, through: 24, by: 2) {
           h1 = SunCalc.getMoonPosition(from: DateUtils.getHoursLater(date: date, hours: Double(i))!, latitude: latitude, longitude: longitude).altitude - hc
           h2 = SunCalc.getMoonPosition(from: DateUtils.getHoursLater(date: date, hours: Double(i + 1))!, latitude: latitude, longitude: longitude).altitude - hc
           a = (h0 + h2) / 2 - h1
           b = (h2 - h0) / 2
           xe = -b / (2 * a)
           ye = (a * xe + b) * xe + h1
           d = b * b - 4 * a * h1
           roots = 0

           if d >= 0 {
               dx = sqrt(d) / (abs(a) * 2)
               x1 = xe - dx
               x2 = xe + dx
               if abs(x1) <= 1 {
                   roots += 1
               }
               if abs(x2) <= 1 {
                   roots += 1
               }
               if x1 < -1 {
                   x1 = x2
               }
           }

           if roots == 1 {
               if h0 < 0 {
                   rise = Double(i) + x1
               } else {
                   set = Double(i) + x1
               }
           } else if roots == 2 {
               rise = Double(i) + (ye < 0 ? x2 : x1)
               set = Double(i) + (ye < 0 ? x1 : x2)
           }

           if (rise != 0) && (set != 0) {
               break
           }
           h0 = h2
        }
        if rise == 0 && set == 0 {
            horizon = ye > 0 ? .alwaysAbove : .alwaysBelow
        } else {
            horizon = .riseAndSets
            self.rise = DateUtils.getHoursLater(date: date, hours: rise)
            self.set = DateUtils.getHoursLater(date: date, hours: set)
        }
    }
}

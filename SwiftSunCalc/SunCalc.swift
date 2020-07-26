//
//  suncalc.swift
//  suncalc
//
//  Originated from https://github.com/mourner/suncalc , a JS library.
//  First converted to Swift by Shaun Meredith on 10/2/14.
//
//

import Foundation

public class SunCalc {
    let J0 = 0.0009
    
    static func getSetJ(h:Double, phi:Double, dec:Double, lw:Double, n:Double, M:Double, L:Double) -> Double {
        let w:Double = TimeUtils.getHourAngle(h:h, phi: phi, d: dec)
        let a:Double = TimeUtils.getApproxTransit(ht: w, lw: lw, n: n)
        
        return TimeUtils.getSolarTransitJ(ds: a, M: M, L: L)
    }
    
    static func getTimes(from date: Date, latitude: Double, longitude: Double) -> SunTimes {
        return SunTimes(date:date, latitude:latitude, longitude:longitude)
    }
    
    static func getSunPosition(from date: Date, latitude: Double, longitude: Double) -> SunPosition {
        return SunPosition(date: date, latitude: latitude, longitude: longitude)
    }
    
    static func getMoonPosition(from date: Date, latitude: Double, longitude: Double) -> MoonPosition {
        return MoonPosition(date: date, latitude: latitude, longitude: longitude)
    }
    
    static func getMoonIllumination(from date: Date) -> MoonIllumination {
        return MoonIllumination(date: date)
    }
    
    static func getMoonTimes(from date: Date, latitude: Double, longitude: Double) -> MoonTimes {
        return MoonTimes(date: date, latitude: latitude, longitude: longitude)
    }
    
}

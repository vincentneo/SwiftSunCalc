//
//  Times.swift
//  SwiftSunCalc
//
//  Created by Vincent Neo on 26/7/20.
//  Copyright © 2020 Vincent Neo. All rights reserved.
//

import Foundation

struct SunTimes {
    var sunrise: Date
    var sunriseEnd: Date
    var goldenHourEnd: Date
    var solarNoon: Date
    var goldenHour: Date
    var sunsetStart: Date
    var sunset: Date
    var dusk: Date
    var nauticalDusk: Date
    var night: Date
    var nadir: Date
    var nightEnd: Date
    var nauticalDawn: Date
    var dawn: Date
    
    init(date: Date, latitude: Double, longitude: Double) {
        let lw:Double = Double.rad * -longitude
        let phi:Double = Double.rad * latitude
        let d:Double = DateUtils.toDays(date: date)
        
        let n:Double = TimeUtils.getJulianCycle(d: d, lw: lw)
        let ds:Double = TimeUtils.getApproxTransit(ht: 0, lw: lw, n: n)
        
        let M:Double = SunUtils.getSolarMeanAnomaly(d: ds)
        let L:Double = SunUtils.getEclipticLongitudeM(M: M)
        let dec:Double = PositionUtils.getDeclination(l: L, b: 0)
        
        let Jnoon:Double = TimeUtils.getSolarTransitJ(ds: ds, M: M, L: L)
        
        self.solarNoon = DateUtils.fromJulian(j: Jnoon)
        self.nadir = DateUtils.fromJulian(j: Jnoon - 0.5)
        
        // sun times configuration (angle, morning name, evening name)
        // unrolled the loop working on this data:
        // var times = [
        //             [-0.83, 'sunrise',       'sunset'      ],
        //             [ -0.3, 'sunriseEnd',    'sunsetStart' ],
        //             [   -6, 'dawn',          'dusk'        ],
        //             [  -12, 'nauticalDawn',  'nauticalDusk'],
        //             [  -18, 'nightEnd',      'night'       ],
        //             [    6, 'goldenHourEnd', 'goldenHour'  ]
        //             ];
        
        var h:Double = -0.83
        var Jset:Double = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        var Jrise:Double = Jnoon - (Jset - Jnoon)
        
        self.sunrise = DateUtils.fromJulian(j: Jrise)
        self.sunset = DateUtils.fromJulian(j: Jset)
        
        h = -0.3
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.sunriseEnd = DateUtils.fromJulian(j: Jrise)
        self.sunsetStart = DateUtils.fromJulian(j: Jset)
        
        h = -6
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.dawn = DateUtils.fromJulian(j: Jrise)
        self.dusk = DateUtils.fromJulian(j: Jset)
        
        h = -12
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.nauticalDawn = DateUtils.fromJulian(j: Jrise)
        self.nauticalDusk = DateUtils.fromJulian(j: Jset)
        
        h = -18
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.nightEnd = DateUtils.fromJulian(j: Jrise)
        self.night = DateUtils.fromJulian(j: Jset)
        
        h = 6
        Jset = SunCalc.getSetJ(h: h * Double.rad, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        Jrise = Jnoon - (Jset - Jnoon)
        self.goldenHourEnd = DateUtils.fromJulian(j: Jrise)
        self.goldenHour = DateUtils.fromJulian(j: Jset)

    }
}

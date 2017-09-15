//
//  SSLunarDateHoliday.h
//  SSLunarDate
//
//  Created by Jiejing Zhang on 13-2-20.
//  Copyright (c) 2013 Jiejing Zhang. All rights reserved.

//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software Foundation,
//  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//

#import <Foundation/Foundation.h>

#import "SSLunarDate.h"
//#import "SSHolidayManager.h"
#import "libLunar.h"



@interface SSLunarDateHoliday : NSObject

+(id) sharedSSLunarDateHoliday;

- (NSString *) getQingmingDate: (NSInteger) solarYear;

- (NSString *) getDongzhiDate: (NSInteger) solarYear;

- (BOOL) isDateLunarHoliday:(LibLunarContext *) lunar region:(SSHolidayRegion) region;

- (NSString *) getLunarHolidayNameForDate: (LibLunarContext *) lunar region:(SSHolidayRegion) region;

+ (NSString *) convertIndexFrom:(NSInteger) month day: (NSInteger) day;

@end

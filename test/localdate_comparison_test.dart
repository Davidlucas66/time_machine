// Portions of this work are Copyright 2018 The Time Machine Authors. All rights reserved.
// Portions of this work are Copyright 2018 The Noda Time Authors. All rights reserved.
// Use of this source code is governed by the Apache License 2.0, as found in the LICENSE.txt file.

import 'dart:async';

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import 'time_machine_testing.dart';

Future main() async {
  await runTests();
}

@Test()
void Equals_EqualValues()
{
  CalendarSystem calendar = CalendarSystem.Julian;
  LocalDate date1 = new LocalDate(2011, 1, 2, calendar);
  LocalDate date2 = new LocalDate(2011, 1, 2, calendar);
  expect(date1, date2);
  expect(date1.hashCode, date2.hashCode);
  expect(date1 == date2, isTrue);
  expect(date1 != date2, isFalse);
  expect(date1.equals(date2), isTrue); // IEquatable implementation
}

@Test()
void Equals_DifferentDates()
{
  CalendarSystem calendar = CalendarSystem.Julian;
  LocalDate date1 = new LocalDate(2011, 1, 2, calendar);
  LocalDate date2 = new LocalDate(2011, 1, 3, calendar);
  expect(date1, isNot(date2));
  expect(date1.hashCode, isNot(date2.hashCode));
  expect(date1 == date2, isFalse);
  expect(date1 != date2, isTrue);
  expect(date1.equals(date2), isFalse); // IEquatable implementation
}

@Test()
void Equals_DifferentCalendars()
{
  CalendarSystem calendar = CalendarSystem.Julian;
  LocalDate date1 = new LocalDate(2011, 1, 2, calendar);
  LocalDate date2 = new LocalDate(2011, 1, 2, CalendarSystem.Iso);
  expect(date1, isNot(date2));
  expect(date1.hashCode, isNot(date2.hashCode));
  expect(date1 == date2, isFalse);
  expect(date1 != date2, isTrue);
  expect(date1.equals(date2), isFalse); // IEquatable implementation
}

@Test()
void Equals_DifferentToNull()
{
  LocalDate date = new LocalDate(2011, 1, 2);
  expect(date.equals(null), isFalse);
}

@Test()
void Equals_DifferentToOtherType()
{
  LocalDate date = new LocalDate(2011, 1, 2);
  // ignore: unrelated_type_equality_checks
  expect(date == new Instant.fromUnixTimeTicks(0), isFalse);
}

@Test()
void ComparisonOperators_SameCalendar()
{
  LocalDate date1 = new LocalDate(2011, 1, 2);
  LocalDate date2 = new LocalDate(2011, 1, 2);
  LocalDate date3 = new LocalDate(2011, 1, 5);

  expect(date1 < date2, isFalse);
  expect(date1 < date3, isTrue);
  expect(date2 < date1, isFalse);
  expect(date3 < date1, isFalse);

  expect(date1 <= date2, isTrue);
  expect(date1 <= date3, isTrue);
  expect(date2 <= date1, isTrue);
  expect(date3 <= date1, isFalse);

  expect(date1 > date2, isFalse);
  expect(date1 > date3, isFalse);
  expect(date2 > date1, isFalse);
  expect(date3 > date1, isTrue);

  expect(date1 >= date2, isTrue);
  expect(date1 >= date3, isFalse);
  expect(date2 >= date1, isTrue);
  expect(date3 >= date1, isTrue);
}

@Test()
void ComparisonOperators_DifferentCalendars_Throws()
{
  LocalDate date1 = new LocalDate(2011, 1, 2);
  LocalDate date2 = new LocalDate(2011, 1, 3, CalendarSystem.Julian);

  // Assert.Throws<ArgumentException>
  expect(() => (date1 < date2).toString(), throwsArgumentError);
  expect(() => (date1 <= date2).toString(), throwsArgumentError);
  expect(() => (date1 > date2).toString(), throwsArgumentError);
  expect(() => (date1 >= date2).toString(), throwsArgumentError);
}

@Test()
void CompareTo_SameCalendar()
{
  LocalDate date1 = new LocalDate(2011, 1, 2);
  LocalDate date2 = new LocalDate(2011, 1, 2);
  LocalDate date3 = new LocalDate(2011, 1, 5);

  expect(date1.compareTo(date2), 0);
  expect(date1.compareTo(date3), lessThan(0));
  expect(date3.compareTo(date2), greaterThan(0));
}

@Test() @SkipMe.unimplemented()
void CompareTo_DifferentCalendars_Throws()
{
  dynamic IslamicLeapYearPattern = null;
  dynamic IslamicEpoch = null;

  CalendarSystem islamic = CalendarSystem.GetIslamicCalendar(IslamicLeapYearPattern.Base15, IslamicEpoch.Astronomical);
  LocalDate date1 = new LocalDate(2011, 1, 2);
  LocalDate date2 = new LocalDate(1500, 1, 1, islamic);

  // Assert.Throws<ArgumentException>
  expect(() => date1.compareTo(date2), throwsArgumentError);
  // todo: Do the Comparable equivalent for Dart
  // expect(() => ((IComparable) date1).CompareTo(date2), throwsArgumentError);
  expect(() => date1.compareTo(date2), throwsArgumentError);
}

/// IComparable.CompareTo works properly with LocalDate inputs with same calendar.
@Test()
void IComparableCompareTo_SameCalendar()
{
  var instance = new LocalDate(2012, 3, 5);
  Comparable<LocalDate> i_instance = instance;

  var later = new LocalDate(2012, 6, 4);
  var earlier = new LocalDate(2012, 1, 4);
  var same = new LocalDate(2012, 3, 5);

  expect(i_instance.compareTo(later), lessThan(0));
  expect(i_instance.compareTo(earlier), greaterThan(0));
  expect(i_instance.compareTo(same), 0);
}

///// IComparable.CompareTo returns a positive number for a null input.
///// 
//@Test()
//void IComparableCompareTo_Null_Positive()
//{
//  var instance = new LocalDate(2012, 3, 5);
//  var i_instance = instance as Comparable<LocalDate>;
//  Object arg = null;
//  var result = i_instance.compareTo(arg);
//  expect(result, greaterThan(0));
//}

///// IComparable.CompareTo throws an ArgumentException for non-null arguments
///// that are not a LocalDate.
///// 
//@Test()
//void IComparableCompareTo_WrongType_ArgumentException()
//{
//  var instance = new LocalDate(2012, 3, 5);
//  var i_instance = instance as Comparable<LocalDate>;
//  var arg = new LocalDateTime.fromYMDHM(2012, 3, 6, 15, 42);
//  // Assert.Throws<ArgumentException>
//  expect(() => i_instance.compareTo(arg), throwsArgumentError);
//}

@Test()
void MinMax_DifferentCalendars_Throws()
{
  LocalDate date1 = new LocalDate(2011, 1, 2);
  LocalDate date2 = new LocalDate(1500, 1, 1, CalendarSystem.Julian);

  // Assert.Throws<ArgumentException>
  expect(() => LocalDate.max(date1, date2), throwsArgumentError);
  expect(() => LocalDate.min(date1, date2), throwsArgumentError);
}

@Test()
void MinMax_SameCalendar()
{
  LocalDate date1 = new LocalDate(1500, 1, 2, CalendarSystem.Julian);
  LocalDate date2 = new LocalDate(1500, 1, 1, CalendarSystem.Julian);

  expect(date1, LocalDate.max(date1, date2));
  expect(date1, LocalDate.max(date2, date1));
  expect(date2, LocalDate.min(date1, date2));
  expect(date2, LocalDate.min(date2, date1));
}

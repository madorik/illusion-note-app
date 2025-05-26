import 'package:intl/intl.dart';

class TimeUtils {
  // 한국 시간대 (UTC+9)
  static const String koreaTimeZone = 'Asia/Seoul';
  
  /// UTC 시간을 한국 시간으로 변환
  static DateTime toKoreaTime(DateTime utcTime) {
    return utcTime.add(const Duration(hours: 9));
  }
  
  /// 현재 한국 시간 반환
  static DateTime nowInKorea() {
    return DateTime.now().toUtc().add(const Duration(hours: 9));
  }
  
  /// 상대적 시간 표시 (한국시간 기준)
  static String getRelativeTime(DateTime dateTime) {
    final now = nowInKorea();
    // 서버에서 받아온 UTC 시간을 한국시간으로 변환
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    final difference = now.difference(koreaDateTime);
    
    // 디버깅용 로그 (개발 중에만 사용)
    // print('TimeUtils.getRelativeTime - Original: $dateTime, Korea: $koreaDateTime, Now: $now, Diff: ${difference.inMinutes}분');
    
    if (difference.isNegative) {
      return '방금 전';
    }
    
    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;
    
    if (seconds < 60) {
      return '방금 전';
    } else if (minutes < 60) {
      return '${minutes}분 전';
    } else if (hours < 24) {
      return '${hours}시간 전';
    } else if (days < 7) {
      return '${days}일 전';
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      return '${weeks}주 전';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '${months}개월 전';
    } else {
      final years = (days / 365).floor();
      return '${years}년 전';
    }
  }
  
  /// 한국시간 기준 날짜 포맷팅
  static String formatKoreaDate(DateTime dateTime, {String pattern = 'yyyy-MM-dd'}) {
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    return DateFormat(pattern).format(koreaDateTime);
  }
  
  /// 한국시간 기준 시간 포맷팅
  static String formatKoreaTime(DateTime dateTime, {String pattern = 'HH:mm'}) {
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    return DateFormat(pattern).format(koreaDateTime);
  }
  
  /// 한국시간 기준 날짜+시간 포맷팅
  static String formatKoreaDateTime(DateTime dateTime, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    return DateFormat(pattern).format(koreaDateTime);
  }
  
  /// 오늘인지 확인 (한국시간 기준)
  static bool isToday(DateTime dateTime) {
    final now = nowInKorea();
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    
    return now.year == koreaDateTime.year &&
           now.month == koreaDateTime.month &&
           now.day == koreaDateTime.day;
  }
  
  /// 어제인지 확인 (한국시간 기준)
  static bool isYesterday(DateTime dateTime) {
    final now = nowInKorea();
    final yesterday = now.subtract(const Duration(days: 1));
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    
    return yesterday.year == koreaDateTime.year &&
           yesterday.month == koreaDateTime.month &&
           yesterday.day == koreaDateTime.day;
  }
  
  /// 이번 주인지 확인 (한국시간 기준)
  static bool isThisWeek(DateTime dateTime) {
    final now = nowInKorea();
    final koreaDateTime = dateTime.isUtc ? toKoreaTime(dateTime) : dateTime;
    
    // 이번 주 시작 (월요일)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    // 이번 주 끝 (일요일)
    final endOfWeek = startOfWeekDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    
    return koreaDateTime.isAfter(startOfWeekDate) && koreaDateTime.isBefore(endOfWeek);
  }
  
  /// 스마트 날짜 표시 (오늘, 어제, 날짜)
  static String getSmartDateDisplay(DateTime dateTime) {
    if (isToday(dateTime)) {
      return '오늘';
    } else if (isYesterday(dateTime)) {
      return '어제';
    } else {
      return formatKoreaDate(dateTime, pattern: 'M월 d일');
    }
  }
  
  /// 스마트 날짜+시간 표시
  static String getSmartDateTimeDisplay(DateTime dateTime) {
    final smartDate = getSmartDateDisplay(dateTime);
    final time = formatKoreaTime(dateTime);
    
    if (smartDate == '오늘' || smartDate == '어제') {
      return '$smartDate $time';
    } else {
      return '$smartDate $time';
    }
  }
} 
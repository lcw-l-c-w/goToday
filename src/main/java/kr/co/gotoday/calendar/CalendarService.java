package kr.co.gotoday.calendar;

import kr.co.gotoday.user.CalendarVO;

public interface CalendarService {
	void addPick(CalendarVO vo);
	
	void removeCalendar(CalendarVO vo);
}

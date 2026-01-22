package kr.co.gotoday.calendar;

import java.util.List;

import kr.co.gotoday.user.CalendarVO;

public interface CalendarService {
	void addPick(CalendarVO vo);
	
	void removeCalendar(CalendarVO vo);

	List<CalendarDTO> getMySchedule(int user_id);
}

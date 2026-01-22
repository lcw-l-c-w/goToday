package kr.co.gotoday.calendar;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.user.CalendarVO;

@Mapper
public interface CalendarMapper {
	void insertCalendar(CalendarVO vo);
	
	void deleteCalendar(CalendarVO vo);
	
	List<CalendarDTO> getCalendarList(int user_id);
}

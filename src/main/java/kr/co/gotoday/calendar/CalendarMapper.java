package kr.co.gotoday.calendar;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.user.CalendarVO;

@Mapper
public interface CalendarMapper {
	void insertCalendar(CalendarVO vo);
	
	void deleteCalendar(CalendarVO vo);
}

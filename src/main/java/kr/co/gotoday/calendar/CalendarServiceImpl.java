package kr.co.gotoday.calendar;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.gotoday.user.CalendarVO;

@Service
public class CalendarServiceImpl implements CalendarService {

	@Autowired
    private CalendarMapper calendarMapper;
	@Override
	public void addPick(CalendarVO vo) {
		// TODO Auto-generated method stub
		calendarMapper.insertCalendar(vo);
		
	}
	
	
	@Override
	public void removeCalendar(CalendarVO vo) {
	    calendarMapper.deleteCalendar(vo);
	}


	@Override
	public List<CalendarDTO> getMySchedule(int user_id) {
		return calendarMapper.getCalendarList(user_id);
		
	}

}

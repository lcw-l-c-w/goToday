package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.transaction.annotation.Transactional;

import config.MvcConfig;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.user.CalendarVO;

@SpringJUnitConfig
@ContextConfiguration(classes = { MvcConfig.class })
@Transactional   // 테스트 끝나면 자동 롤백
class ReservationMapperTest {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private ReservationMapper mapper() {
        return sqlSession.getMapper(ReservationMapper.class);
    }

    @Test
    void createReservation_정상삽입_및_PK_조회() {
        ReservationVO vo = new ReservationVO();
        vo.setReservation_code("TEST-20260119-001");
        vo.setReserved_for_at("20260128");
        vo.setTime_zone("10:00~12:00");
        vo.setReservation_status("DONE");
        vo.setTotal_price(30000);
        vo.setAdult_qty(2);
        vo.setChild_qty(0);
        vo.setTeen_qty(0);
        vo.setUser_id(22);
        vo.setContent_id(5);
        vo.setReservation_type("NORMAL");
        vo.setReceiver_name("테스트유저");
        vo.setReceiver_birth("1995-01-01");
        vo.setReceiver_phone("01012341234");
        vo.setReceive_type("ONLINE");
        vo.setSchedule_id(2);

        int result = mapper().createReservation(vo);

        assertEquals(1, result);
        assertNotNull(vo.getReservation_id());

        ReservationVO saved = mapper().findByReservationId(vo.getReservation_id());
        assertEquals("TEST-20260119-001", saved.getReservation_code());
    }

    @Test
    void createScheduleByReservation_캘린더_삽입() {
        CalendarVO cal = new CalendarVO();
        cal.setSelected_at("20260128 10:00~12:00");
        cal.setType("reserve");
        cal.setContent_id(5);
        cal.setUser_id(22);
        cal.setReservation_id(9999); // 임시

        int result = mapper().createScheduleByReservation(cal);
        assertEquals(1, result);
    }

    @Test
    void findByOrderId_결제조회() {
        PaymentVO payment = mapper().findByOrderId("ORDER-TEST-001");
        if (payment != null) {
            assertEquals("ORDER-TEST-001", payment.getOrder_key());
        }
    }

    @Test
    void subCurrentTicket_차감성공() {
        Map<String, Object> param = new HashMap<>();
        param.put("schedule_id", 51);
        param.put("total_qty", 2);

        int result = mapper().subCurrentTicket(param);
        assertEquals(1, result);
    }

    @Test
    void addCurrentTicket_복구성공() {
        Map<String, Object> param = new HashMap<>();
        param.put("schedule_id", 51);
        param.put("total_qty", 2);

        int result = mapper().addCurrentTicket(param);
        assertEquals(1, result);
    }

    @Test
    void updatePaymentStatus_결제상태변경() {
        Map<String, Object> param = new HashMap<>();
        param.put("order_key", "ORDER-TEST-001");
        param.put("payment_status", "DONE");

        int result = mapper().updatePaymentStatus(param);
        assertEquals(1, result);
    }
}
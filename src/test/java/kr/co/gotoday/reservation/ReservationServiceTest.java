package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.content.ContentVo;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {config.MvcConfig.class})
@PropertySource("classpath:db.properties")
@WebAppConfiguration
@Transactional
class ReservationServiceTest {

    @Autowired
    private ReservationService reservationService;
    
    @Autowired
    private ReservationMapper reservationMapper;
    
    private ReservationDTO reservationDTO;
    private ContentVo contentVo;
    private ReservationVO reservationVO;
    
    @BeforeEach
    void setUp() {
        // 테스트용 예약 데이터 준비
        reservationDTO = new ReservationDTO();
        reservationDTO.setAdult_qty(2);
        reservationDTO.setTeen_qty(1);
        reservationDTO.setChild_qty(1);
        
        // 테스트용 콘텐츠 데이터 준비
        contentVo = new ContentVo();
        contentVo.setTitle("무한도전");
        contentVo.setAdult_price(17000);
        contentVo.setTeen_price(12000);
        contentVo.setChild_price(8000);
        
        // 테스트용 결제 데이터 준비
        reservationVO = new ReservationVO();
        reservationVO.setReservation_code("TEST_" + System.currentTimeMillis());
        reservationVO.setReservation_status("PENDING");
        reservationVO.setTotal_price(54000);
        reservationVO.setAdult_qty(2);
        reservationVO.setTeen_qty(1);
        reservationVO.setChild_qty(1);
        reservationVO.setUser_id(1);
        reservationVO.setContent_id(1);
        reservationVO.setReservation_type("ONLINE");
        reservationVO.setReceiver_name("홍길동");
        reservationVO.setReceiver_birth("19900101");
        reservationVO.setReceiver_phone("01012345678");
    }
    
    // ==================== calculate() 메서드 테스트 ====================
    
    @Test
    @DisplayName("정상적인 가격 계산 테스트")
    void 가격계산_정상() {
        // given: 성인 2명(17000), 청소년 1명(12000), 어린이 1명(8000)
        
        // when
        int totalPrice = reservationService.calculate(reservationDTO, contentVo);
        
        // then
        int expected = (2 * 17000) + (1 * 12000) + (1 * 8000); // 54000
        assertEquals(expected, totalPrice);
    }
    
    @Test
    @DisplayName("성인만 있는 경우 가격 계산")
    void 가격계산_성인만() {
        // given
        reservationDTO.setAdult_qty(3);
        reservationDTO.setTeen_qty(0);
        reservationDTO.setChild_qty(0);
        
        // when
        int totalPrice = reservationService.calculate(reservationDTO, contentVo);
        
        // then
        assertEquals(3 * 17000, totalPrice);
    }
    
    @Test
    @DisplayName("모든 수량이 0인 경우")
    void 가격계산_수량0() {
        // given
        reservationDTO.setAdult_qty(0);
        reservationDTO.setTeen_qty(0);
        reservationDTO.setChild_qty(0);
        
        // when
        int totalPrice = reservationService.calculate(reservationDTO, contentVo);
        
        // then
        assertEquals(0, totalPrice);
    }
    
    @Test
    @DisplayName("calculate - null 값 입력 시 예외 발생")
    void 가격계산_null체크() {
        // when & then
        assertThrows(IllegalArgumentException.class, () -> {
            reservationService.calculate(null, contentVo);
        });
        
        assertThrows(IllegalArgumentException.class, () -> {
            reservationService.calculate(reservationDTO, null);
        });
    }
    
    // ==================== payment() 메서드 테스트 ====================
    
    @Test
    @DisplayName("결제 정보 저장 성공")
    void 결제정보_저장_성공() {
        // when
        int result = reservationService.payment(reservationVO);
        
        // then
        assertEquals(1, result, "INSERT 성공 시 1을 반환해야 함");
    }
    
    @Test
    @DisplayName("결제 정보 저장 후 DB 조회 확인")
    void 결제정보_저장_후_조회() {
        // given
        reservationService.payment(reservationVO);
        
        // when
        ReservationVO saved = reservationMapper.findByReservationCode(
            reservationVO.getReservation_code()
        );
        
        // then
        assertNotNull(saved);
        assertEquals(reservationVO.getReservation_code(), saved.getReservation_code());
        assertEquals(reservationVO.getTotal_price(), saved.getTotal_price());
        assertEquals(reservationVO.getReceiver_name(), saved.getReceiver_name());
    }
    
    @Test
    @DisplayName("payment - 필수 값 누락 시 예외 발생")
    void 결제정보_필수값_누락() {
        // given
        reservationVO.setReservation_code(null); // 필수값 누락
        
        // when & then
        assertThrows(Exception.class, () -> {
            reservationService.payment(reservationVO);
        });
    }
    
    @Test
    @DisplayName("payment - 중복 예약코드 저장 시도")
    void 결제정보_중복_예약코드() {
        // given - 첫 번째 저장
        reservationService.payment(reservationVO);
        
        // when & then - 같은 예약코드로 다시 저장 시도
        ReservationVO duplicate = new ReservationVO();
        duplicate.setReservation_code(reservationVO.getReservation_code()); // 같은 코드
        duplicate.setTotal_price(10000);
        duplicate.setUser_id(2);
        duplicate.setContent_id(2);
        
        assertThrows(Exception.class, () -> {
            reservationService.payment(duplicate);
        });
    }
    
    @Test
    @DisplayName("여러 건의 결제 정보 저장")
    void 다건_결제정보_저장() {
        // given
        ReservationVO reservation1 = createReservationVO("CODE1", 10000);
        ReservationVO reservation2 = createReservationVO("CODE2", 20000);
        ReservationVO reservation3 = createReservationVO("CODE3", 30000);
        
        // when
        int result1 = reservationService.payment(reservation1);
        int result2 = reservationService.payment(reservation2);
        int result3 = reservationService.payment(reservation3);
        
        // then
        assertEquals(1, result1);
        assertEquals(1, result2);
        assertEquals(1, result3);
    }
    
    // ==================== 통합 테스트 ====================
    
    @Test
    @DisplayName("가격 계산 후 결제 정보 저장 - 통합 테스트")
    void 가격계산_후_결제저장_통합() {
        // given - 가격 계산
        int calculatedPrice = reservationService.calculate(reservationDTO, contentVo);
        
        // when - 계산된 가격으로 결제 정보 저장
        reservationVO.setTotal_price(calculatedPrice);
        int result = reservationService.payment(reservationVO);
        
        // then
        assertEquals(1, result);
        
        // 저장된 데이터 확인
        ReservationVO saved = reservationMapper.findByReservationCode(
            reservationVO.getReservation_code()
        );
        assertEquals(calculatedPrice, saved.getTotal_price());
    }
    
    // ==================== Helper 메서드 ====================
    
    private ReservationVO createReservationVO(String code, int price) {
        ReservationVO vo = new ReservationVO();
        vo.setReservation_code(code);
        vo.setReservation_status("PENDING");
        vo.setTotal_price(price);
        vo.setAdult_qty(1);
        vo.setTeen_qty(0);
        vo.setChild_qty(0);
        vo.setUser_id(1);
        vo.setContent_id(1);
        vo.setReservation_type("ONLINE");
        vo.setReceiver_name("테스트");
        vo.setReceiver_birth("19900101");
        vo.setReceiver_phone("01012345678");
        return vo;
    }
}
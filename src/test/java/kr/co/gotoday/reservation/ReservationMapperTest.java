package kr.co.gotoday.reservation;

@SpringBootTest
@Transactional
class ReservationMapperTest {

    @Autowired
    ReservationMapper reservationMapper;

    @Test
    void findReservationByVendor_basic() {
        VendorReservationSearchDTO dto = new VendorReservationSearchDTO();
        dto.setUser_id(1);
        dto.setLimit(10);
        dto.setOffset(0);

        List<VendorReservationListDTO> list =
                reservationMapper.findReservationByVendor(dto);

        int count =
                reservationMapper.countReservationByVendor(dto);

        System.out.println("list size = " + list.size());
        System.out.println("count = " + count);

        assertTrue(count >= list.size());
    }

    @Test
    void findReservationByVendor_withFilters() {
        VendorReservationSearchDTO dto = new VendorReservationSearchDTO();
        dto.setUser_id(1);
        dto.setContent_id(3);
        dto.setReservation_status("DONE");
        dto.setPayment_status("DONE");
        dto.setKeyword("RES");
        dto.setLimit(10);
        dto.setOffset(0);

        List<VendorReservationListDTO> list =
                reservationMapper.findReservationByVendor(dto);

        list.forEach(System.out::println);
    }
}

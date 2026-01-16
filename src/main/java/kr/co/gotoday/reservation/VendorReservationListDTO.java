package kr.co.gotoday.reservation;

public class VendorReservationListDTO {
	private int reservation_id;
	private String reservation_code;
	private String reserved_for_at;
	private int adult_qty;
	private int child_qty;
	private int teen_qty;
	private String reservation_status;
	private String receiver_name;
	private String receiver_birth;
	private String receiver_phone;
	private int payment_id;
	private String payment_status;
	private int content_id;
	private String title;

	// Getters
	public int getReservation_id() {
		return reservation_id;
	}

	public String getReservation_code() {
		return reservation_code;
	}

	public String getReserved_for_at() {
		return reserved_for_at;
	}

	public int getAdult_qty() {
		return adult_qty;
	}

	public int getChild_qty() {
		return child_qty;
	}

	public int getTeen_qty() {
		return teen_qty;
	}

	public String getReservation_status() {
		return reservation_status;
	}

	public String getReceiver_name() {
		return receiver_name;
	}

	public String getReceiver_birth() {
		return receiver_birth;
	}

	public String getReceiver_phone() {
		return receiver_phone;
	}

	public int getPayment_id() {
		return payment_id;
	}

	public String getPayment_status() {
		return payment_status;
	}

	public int getContent_id() {
		return content_id;
	}

	public String getTitle() {
		return title;
	}

	// Setters
	public void setReservation_id(int reservation_id) {
		this.reservation_id = reservation_id;
	}

	public void setReservation_code(String reservation_code) {
		this.reservation_code = reservation_code;
	}

	public void setReserved_for_at(String reserved_for_at) {
		this.reserved_for_at = reserved_for_at;
	}

	public void setAdult_qty(int adult_qty) {
		this.adult_qty = adult_qty;
	}

	public void setChild_qty(int child_qty) {
		this.child_qty = child_qty;
	}

	public void setTeen_qty(int teen_qty) {
		this.teen_qty = teen_qty;
	}

	public void setReservation_status(String reservation_status) {
		this.reservation_status = reservation_status;
	}

	public void setReceiver_name(String receiver_name) {
		this.receiver_name = receiver_name;
	}

	public void setReceiver_birth(String receiver_birth) {
		this.receiver_birth = receiver_birth;
	}

	public void setReceiver_phone(String receiver_phone) {
		this.receiver_phone = receiver_phone;
	}

	public void setPayment_id(int payment_id) {
		this.payment_id = payment_id;
	}

	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}

	public void setContent_id(int content_id) {
		this.content_id = content_id;
	}

	public void setTitle(String title) {
		this.title = title;
	}
}

package kr.co.gotoday.content;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class MainContentViewDTO {
	//화면에 표현할 상태 (화면 표현 상태)
	
	//일단 띄워야할 것 
	private long contentId;
	private String title;
	private String main_image_path;
	private String category; // 태그 관련 
	private String location; //장소
	private String content_kind;
	// 날짜 25.12.22~ 26.01.31 
	private Timestamp start_at;
	private Timestamp end_at;
	
	
	
	//화면 표현용
	private boolean blur; //블러 처리여부
	private String ctaMessage; //요청 메세지 ( 로그인하시면 볼 수 있습니다 (로그인하기 ) || 관심사 설정해주세요 ! (관심사 설정하러가기 ))
	private String ctaUrl; //버튼 누르면 이동될 uri로 확인이 됨.

	
	private String periodText; // "25.12.25~26.01.01"
	private Integer dday;      // 시작일까지 남은 일수 (0이면 D-0, 음수면 이미 시작)

}
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>예약 완료</title>
</head>
<body>
    <!-- ===================== HEADER ===================== -->
    <header>
        <a href="#" aria-label="GoToday 홈">GoToday</a>

        <nav aria-label="메인 메뉴">
            <a href="#">Q&amp;A</a>
            <a href="#">PopUp</a>
            <a href="#">Exhibition</a>
        </nav>

        <div>
            <button type="button" name="btnSearch" aria-label="검색">
                검색
            </button>
            <a href="#" aria-label="마이페이지">마이페이지</a>
        </div>
    </header>

    <hr />

    <!-- ===================== MAIN ===================== -->
    <main>
        <section aria-label="예약 완료 안내">
            <h1>예약이 완료되었습니다</h1>

            <!-- 완료 화면에서 필요할 수 있는 hidden 값들(나중에 바인딩) -->
            <form action="#" method="get">
                <input type="hidden" name="reservationId" value="" />
                <input type="hidden" name="paymentId" value="" />
                <input type="hidden" name="contentId" value="" />

                <div>
                    <button type="submit" name="btnGoHome" formaction="#">
                        메인화면
                    </button>
                    <button
                        type="submit"
                        name="btnGoReservationDetail"
                        formaction="#"
                    >
                        예약 상세 정보
                    </button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
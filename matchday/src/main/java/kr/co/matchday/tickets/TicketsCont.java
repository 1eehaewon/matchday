package kr.co.matchday.tickets;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.example.websocket.WebSocketController;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 티켓 관련 요청을 처리하는 Spring MVC 컨트롤러.
 * 클라이언트 요청에 따라 티켓 결제, 좌석 지도, 예약 등을 처리.
 */
@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private TicketsService ticketsService; // 티켓 관련 서비스

    @Autowired
    private WebSocketController webSocketController; // WebSocket 컨트롤러

    @Autowired
    private Environment env; // 애플리케이션 환경 설정

    // 디버깅용으로 컨트롤러 객체 생성 시 출력
    public TicketsCont() {
        System.out.println("----TicketsController() 객체 생성");
    }

    /**
     * 결제 페이지를 반환.
     * @param matchid 경기 ID
     * @return ModelAndView 결제 페이지
     */
    @GetMapping("/ticketspayment")
    public ModelAndView ticketspayment(@RequestParam String matchid) {
        System.out.println("Received matchid: " + matchid);
        // 티켓 결제 페이지를 생성하고 반환
        return ticketsService.getTicketPaymentPage(matchid);
    }

    /**
     * 좌석 지도 페이지를 반환.
     * @param stadiumid 경기장 ID
     * @param section 섹션
     * @param matchid 경기 ID
     * @return ModelAndView 좌석 지도 페이지
     */
    @GetMapping("/seatmap")
    public ModelAndView seatmap(@RequestParam String stadiumid, @RequestParam String section, @RequestParam String matchid) {
        // 좌석 지도 페이지를 생성하고 반환
        return ticketsService.getSeatMapPage(stadiumid, section, matchid);
    }

    /**
     * 예약 페이지를 반환.
     * @param matchId 경기 ID
     * @param seatsJson 선택된 좌석 정보 (JSON 문자열)
     * @param totalPrice 총 가격
     * @param section 섹션
     * @param stadiumId 경기장 ID
     * @param session HTTP 세션 객체
     * @param model Spring Model 객체
     * @return 예약 페이지
     */
    @GetMapping("/reservation")
    public String showReservationPage(
            @RequestParam("matchid") String matchId,
            @RequestParam("seats") String seatsJson,
            @RequestParam("totalPrice") int totalPrice,
            @RequestParam("section") String section,
            @RequestParam("stadiumid") String stadiumId,
            HttpSession session,
            Model model) {
        // 예약 페이지를 생성하고 반환
        return ticketsService.getReservationPage(matchId, seatsJson, totalPrice, section, stadiumId, session, model);
    }

    /**
     * 결제 검증을 처리.
     * @param requestParams 결제 요청 파라미터
     * @param seatsJson 선택된 좌석 정보 (JSON 문자열)
     * @param session HTTP 세션 객체
     * @return 결제 검증 결과를 포함하는 Map
     */
    @PostMapping("/verifyPayment")
    @ResponseBody
    public Map<String, Object> verifyPayment(
            @RequestParam Map<String, String> requestParams,
            @RequestParam("seats") String seatsJson,
            HttpSession session) {
        // 결제 검증을 처리하고 결과를 반환
        return ticketsService.verifyPayment(requestParams, seatsJson, session, webSocketController, env);
    }

    /**
     * 결제 취소를 처리.
     * @param reservationid 예약 ID
     * @return 결제 취소 결과를 포함하는 Map
     */
    @PostMapping("/cancelPayment")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam("reservationid") String reservationid) {
        // 결제 취소를 처리하고 결과를 반환
        return ticketsService.cancelPayment(reservationid, env);
    }

    /**
     * 예약 목록 페이지를 반환.
     * @param session HTTP 세션 객체
     * @return 예약 목록 페이지
     */
    @GetMapping("/reservationList")
    public ModelAndView reservationList(HttpSession session) {
        // 예약 목록 페이지를 생성하고 반환
        return ticketsService.getReservationListPage(session);
    }

    /**
     * 예약 상세 페이지를 반환.
     * @param reservationid 예약 ID
     * @param session HTTP 세션 객체
     * @return 예약 상세 페이지
     */
    @GetMapping("/reservationDetail")
    public ModelAndView reservationDetail(@RequestParam("reservationid") String reservationid, HttpSession session) {
        // 예약 상세 페이지를 생성하고 반환
        return ticketsService.getReservationDetailPage(reservationid, session);
    }

    /**
     * 예약 ID를 기반으로 QR 코드를 생성.
     * @param reservationid 예약 ID
     * @return QR 코드 이미지 데이터를 포함하는 ResponseEntity
     */
    @GetMapping("/generateQRCode")
    @ResponseBody
    public ResponseEntity<byte[]> generateQRCode(@RequestParam("reservationid") String reservationid) {
        // 예약 ID를 기반으로 QR 코드를 생성하고 반환
        return ticketsService.generateQRCode(reservationid);
    }
    
    /**
     * 모바일 티켓 페이지를 반환.
     * @param reservationId 예약 ID
     * @return ModelAndView 객체
     */
    @GetMapping("/mobileTicket")
    public ModelAndView getMobileTicket(@RequestParam("reservationid") String reservationId) {
        return ticketsService.getMobileTicket(reservationId);
    }
    
    
}

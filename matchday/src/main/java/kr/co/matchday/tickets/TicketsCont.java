package kr.co.matchday.tickets;

import java.util.HashMap;
import java.util.Map;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.matchday.matches.MatchesDTO;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private TicketsDAO ticketsDao;

    public TicketsCont() {
        System.out.println("----TicketsCont() 객체");
    }

    @GetMapping("/ticketspayment")
    public ModelAndView ticketspayment(@RequestParam String matchid) {
        System.out.println("Received matchid: " + matchid);
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        ModelAndView mav = new ModelAndView("tickets/ticketspayment");
        mav.addObject("match", matchesDto);
        return mav;
    }

    @GetMapping("/seatmap")
    public ModelAndView seatmap(@RequestParam String matchid, @RequestParam String section) {
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        Map<String, Object> seatsData = generateSeats(section);
        ModelAndView mav = new ModelAndView("tickets/seatmap");
        mav.addObject("section", section);
        mav.addObject("match", matchesDto);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            mav.addObject("seatsJson", objectMapper.writeValueAsString(seatsData.get("seats")));
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            mav.addObject("seatsJson", "[]");
        }
        return mav;
    }

    @GetMapping("/reservation")
    public ModelAndView reservation(@RequestParam String matchid, @RequestParam String seats, @RequestParam int totalPrice) {
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        
        // 취소일자를 경기일의 3일 전으로 설정
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(matchesDto.getMatchdate());
        calendar.add(Calendar.DAY_OF_MONTH, -3);
        matchesDto.setCancellationDeadline(calendar.getTime());
        
        ModelAndView mav = new ModelAndView("tickets/reservation");
        mav.addObject("match", matchesDto);
        String[] seatArray = seats.split(",");
        mav.addObject("seats", seatArray); // 선택한 좌석 정보를 배열로 전달
        mav.addObject("totalPrice", totalPrice); // 총 티켓 금액 전달
        
        return mav;
    }

    private Map<String, Object> generateSeats(String section) {
        int rows = 20;
        int cols = 20;
        String[][] seats = new String[rows][cols];

        switch (section.toLowerCase()) {
            case "north":
                for (int i = rows - 1; i >= 0; i--) {
                    for (int j = 0; j < cols; j++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(i * cols + j + 1);
                    }
                }
                break;
            case "south":
                for (int i = 0; i < rows; i++) {
                    for (int j = 0; j < cols; j++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(i * cols + j + 1);
                    }
                }
                break;
            case "east":
                for (int j = 0; j < cols; j++) {
                    for (int i = 0; i < rows; i++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(j * rows + i + 1);
                    }
                }
                break;
            case "west":
                for (int j = cols - 1; j >= 0; j--) {
                    for (int i = 0; i < rows; i++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf((cols - j - 1) * rows + i + 1);
                    }
                }
                break;
        }

        Map<String, Object> seatMap = new HashMap<>();
        seatMap.put("seats", seats);
        return seatMap;
    }
}

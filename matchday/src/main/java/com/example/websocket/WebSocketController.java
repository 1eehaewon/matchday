package com.example.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

@Controller
public class WebSocketController {

    private static final Map<String, String> selectedSeats = new HashMap<>();

    @MessageMapping("/selectSeat")
    @SendTo("/topic/seatSelected")
    public SeatMessage selectSeat(SeatMessage message) {
        if ("selected".equals(message.getStatus())) {
            selectedSeats.put(message.getSeatId(), message.getUserId());
        } else if ("reserved".equals(message.getStatus())) {
            selectedSeats.put(message.getSeatId(), "reserved");
        } else {
            selectedSeats.remove(message.getSeatId());
        }
        message.setSelectedSeats(new HashMap<>(selectedSeats));
        return message;
    }

    @MessageMapping("/leaveSeatSelection")
    @SendTo("/topic/seatSelected")
    public SeatMessage leaveSeatSelection(String userId) {
        selectedSeats.entrySet().removeIf(entry -> userId.equals(entry.getValue()));
        SeatMessage message = new SeatMessage();
        message.setSelectedSeats(new HashMap<>(selectedSeats));
        return message;
    }

    @PostMapping("/websocket/checkSelectedSeats")
    @ResponseBody
    public Map<String, Object> checkSelectedSeats(@RequestBody SeatCheckRequest request) {
        Map<String, Object> response = new HashMap<>();
        for (String seatId : request.getSeats()) {
            if (selectedSeats.containsKey(seatId) && !selectedSeats.get(seatId).equals(request.getUserId()) && !selectedSeats.get(seatId).equals("reserved")) {
                response.put("success", false);
                response.put("message", "다른 사용자가 구매중인 좌석이 있습니다.");
                return response;
            }
        }
        response.put("success", true);
        return response;
    }

    public boolean checkIfSeatsAvailable(String[] seats, String userId) {
        for (String seatId : seats) {
            if (selectedSeats.containsKey(seatId) && !selectedSeats.get(seatId).equals(userId) && !selectedSeats.get(seatId).equals("reserved")) {
                return false;
            }
        }
        return true;
    }

    public static class SeatMessage {
        private String seatId;
        private String status;
        private String userId;
        private Map<String, String> selectedSeats;

        // Getters and Setters
        public String getSeatId() {
            return seatId;
        }

        public void setSeatId(String seatId) {
            this.seatId = seatId;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getUserId() {
            return userId;
        }

        public void setUserId(String userId) {
            this.userId = userId;
        }

        public Map<String, String> getSelectedSeats() {
            return selectedSeats;
        }

        public void setSelectedSeats(Map<String, String> selectedSeats) {
            this.selectedSeats = selectedSeats;
        }
    }

    public static class SeatCheckRequest {
        private List<String> seats;
        private String userId;

        // Getters and Setters
        public List<String> getSeats() {
            return seats;
        }

        public void setSeats(List<String> seats) {
            this.seats = seats;
        }

        public String getUserId() {
            return userId;
        }

        public void setUserId(String userId) {
            this.userId = userId;
        }
    }
}

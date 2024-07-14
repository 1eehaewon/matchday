package com.example.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;

@Controller
public class WebSocketController {

    private static final Map<String, String> selectedSeats = new HashMap<>();

    @MessageMapping("/selectSeat")
    @SendTo("/topic/seatSelected")
    public SeatMessage selectSeat(SeatMessage message) {
        if ("selected".equals(message.getStatus())) {
            selectedSeats.put(message.getSeatId(), message.getUserId());
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

    public static class SeatMessage {
        private String seatId;
        private String status;
        private String userId;
        private Map<String, String> selectedSeats;

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
}

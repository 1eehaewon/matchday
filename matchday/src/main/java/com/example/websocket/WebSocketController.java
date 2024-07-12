package com.example.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.Set;

@Controller
public class WebSocketController {

    private static final Set<String> selectedSeats = new HashSet<>();

    @MessageMapping("/selectSeat")
    @SendTo("/topic/seatSelected")
    public SeatMessage selectSeat(SeatMessage message) {
        if ("selected".equals(message.getStatus())) {
            selectedSeats.add(message.getSeatId());
        } else {
            selectedSeats.remove(message.getSeatId());
        }
        message.setSelectedSeats(new HashSet<>(selectedSeats));
        return message;
    }

    public static class SeatMessage {
        private String seatId;
        private String status;
        private Set<String> selectedSeats;

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

        public Set<String> getSelectedSeats() {
            return selectedSeats;
        }

        public void setSelectedSeats(Set<String> selectedSeats) {
            this.selectedSeats = selectedSeats;
        }
    }
}

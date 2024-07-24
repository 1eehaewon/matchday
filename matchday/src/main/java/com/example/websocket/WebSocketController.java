package com.example.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Controller
public class WebSocketController {

    private final SimpMessagingTemplate messagingTemplate;
    private static final Map<String, String> selectedSeats = new ConcurrentHashMap<>();

    @Autowired
    public WebSocketController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/selectSeat")
    @SendTo("/topic/seatSelected")
    public SeatMessage selectSeat(SeatMessage message) {
        String seatId = message.getSeatId();
        String status = message.getStatus();
        String userId = message.getUserId();

        if ("selected".equals(status)) {
            if (selectedSeats.containsKey(seatId) && !selectedSeats.get(seatId).equals(userId)) {
                message.setStatus("unavailable");
            } else {
                selectedSeats.put(seatId, userId);
            }
        } else if ("reserved".equals(status)) {
            selectedSeats.put(seatId, "reserved");
        } else {
            selectedSeats.remove(seatId);
        }

        message.setSelectedSeats(new HashMap<>(selectedSeats));
        return message;
    }

    @MessageMapping("/completeSelection")
    @SendTo("/topic/seatSelected")
    public SeatMessage completeSelection(SeatMessage message) {
        for (String seatId : message.getSeatIds()) {
            selectedSeats.put(seatId, "reserved");
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

    @GetMapping("/seats/status")
    @ResponseBody
    public Map<String, Object> getSeatStatus(@RequestParam String matchid, @RequestParam String section, @RequestParam String stadiumid) {
        Map<String, Object> seatStatus = new HashMap<>();
        seatStatus.put("reservedSeats", selectedSeats.entrySet().stream()
            .filter(entry -> "reserved".equals(entry.getValue()))
            .map(Map.Entry::getKey)
            .collect(Collectors.toList()));
        seatStatus.put("selectedSeats", new HashMap<>(selectedSeats));
        return seatStatus;
    }

    public boolean checkIfSeatsAvailable(String[] seats, String userId) {
        for (String seatId : seats) {
            if (selectedSeats.containsKey(seatId) && !selectedSeats.get(seatId).equals(userId) && !selectedSeats.get(seatId).equals("reserved")) {
                return false;
            }
        }
        return true;
    }

    public void releaseSeat(String seatId, String userId) {
        if (selectedSeats.get(seatId).equals(userId)) {
            selectedSeats.remove(seatId);
            Map<String, String> message = new HashMap<>();
            message.put("seatId", seatId);
            message.put("status", "deselected");
            message.put("userId", userId);
            messagingTemplate.convertAndSend("/topic/seatSelected", message);
        }
    }

    public void releaseSeats(String[] seatIds, String userId) {
        for (String seatId : seatIds) {
            releaseSeat(seatId, userId);
        }
    }

    public static class SeatMessage {
        private String seatId;
        private List<String> seatIds;
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

        public List<String> getSeatIds() {
            return seatIds;
        }

        public void setSeatIds(List<String> seatIds) {
            this.seatIds = seatIds;
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
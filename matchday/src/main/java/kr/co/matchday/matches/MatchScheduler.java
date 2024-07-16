package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.text.SimpleDateFormat;
import java.util.Date;

@Component
public class MatchScheduler {

    @Autowired
    private MatchesDAO matchesDAO;

    // 매일 자정에 실행되는 스케줄러입니다.
    @Scheduled(cron = "0 0 0 * * *")
    public void deleteOldMatches() {
        // 현재 날짜를 가져옵니다.
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String currentDateString = dateFormat.format(currentDate);

        // 지난 경기를 삭제합니다.
        matchesDAO.deleteOldMatches(currentDateString);
    }
}

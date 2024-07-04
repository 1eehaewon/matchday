package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MatchesService {

    @Autowired
    private MatchesDAO matchesDAO;

    public List<String> getAllTeams() {
        return matchesDAO.getAllTeams().stream()
                         .map(MatchesDTO::getTeamname)
                         .collect(Collectors.toList());
    }

    public List<String> getAllStadiums() {
        return matchesDAO.getAllStadiums().stream()
                         .map(MatchesDTO::getStadiumid)
                         .collect(Collectors.toList());
    }

    public void insertMatch(MatchesDTO matchesDTO) {
        // matchid 생성
        String matchdateStr = new SimpleDateFormat("yyyy-MM-dd").format(matchesDTO.getMatchdate());
        String maxMatchId = matchesDAO.getMaxMatchIdForDate(matchdateStr);
        
        String newMatchId;
        if (maxMatchId == null) {
            newMatchId = "match" + matchdateStr.replace("-", "") + "001";
        } else {
            int nextId = Integer.parseInt(maxMatchId.substring(maxMatchId.length() - 3)) + 1;
            newMatchId = "match" + matchdateStr.replace("-", "") + String.format("%03d", nextId);
        }

        matchesDTO.setMatchid(newMatchId);
        matchesDAO.insert(matchesDTO);
    }
}

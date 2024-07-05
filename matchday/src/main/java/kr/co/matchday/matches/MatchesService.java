package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MatchesService {

    @Autowired
    private MatchesDAO matchesDAO;

    public List<String> getAllTeams() {
        return matchesDAO.getAllTeams().stream()
                         .map(team -> (String) team.get("teamname"))
                         .collect(Collectors.toList());
    }

    public List<String> getAllStadiums() {
        return matchesDAO.getAllStadiums().stream()
                         .map(stadium -> (String) stadium.get("stadiumid"))
                         .collect(Collectors.toList());
    }


    public void insertMatch(MatchesDTO matchesDTO) {
        String maxMatchId = matchesDAO.getMaxMatchIdForDate(new SimpleDateFormat("yyyy-MM-dd").format(matchesDTO.getMatchdate()));
        String newMatchId = generateMatchId(maxMatchId, matchesDTO.getMatchdate());
        matchesDTO.setMatchid(newMatchId);
        matchesDAO.insert(matchesDTO);
    }

    private String generateMatchId(String maxMatchId, Date matchdate) {
        String datePrefix = new SimpleDateFormat("yyyyMMdd").format(matchdate);
        int serial = (maxMatchId != null && maxMatchId.startsWith("match" + datePrefix)) 
                     ? Integer.parseInt(maxMatchId.substring(12)) + 1 
                     : 1;
        return "match" + datePrefix + String.format("%03d", serial);
    }

    public List<MatchesDTO> list() {
        return matchesDAO.list();
    }
}

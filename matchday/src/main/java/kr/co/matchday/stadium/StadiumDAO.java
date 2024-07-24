package kr.co.matchday.stadium;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class StadiumDAO {

    @Autowired
    private SqlSession sqlSession;

    @Transactional
    public void insertStadium(StadiumDTO stadiumDTO) {
        String nextStadiumId = getNextStadiumId();
        stadiumDTO.setStadiumId(nextStadiumId);
        sqlSession.insert("kr.co.matchday.stadium.StadiumMapper.insertStadium", stadiumDTO);
        insertSeats(nextStadiumId);
    }

    public String getNextStadiumId() {
        String maxId = sqlSession.selectOne("kr.co.matchday.stadium.StadiumMapper.getMaxStadiumId");
        if (maxId == null) {
            return "stadium01";
        }
        int nextId = Integer.parseInt(maxId.replace("stadium", "")) + 1;
        String newId;
        while (true) {
            newId = String.format("stadium%02d", nextId);
            String existingId = sqlSession.selectOne("kr.co.matchday.stadium.StadiumMapper.getStadiumById", newId);
            if (existingId == null) {
                break;
            }
            nextId++;
        }
        return newId;
    }

    public List<StadiumDTO> getAllStadiums() {
        return sqlSession.selectList("kr.co.matchday.stadium.StadiumMapper.getAllStadiums");
    }

    private void insertSeats(String stadiumId) {
        String[] sections = {"N", "S", "E", "W"};
        int[] prices = {20000, 17000, 18000, 19000};
        int seatCount = 400;

        for (int i = 0; i < sections.length; i++) {
            for (int seatNumber = 1; seatNumber <= seatCount; seatNumber++) {
                Map<String, Object> seatParams = new HashMap<>();
                seatParams.put("seatId", String.format("%s_%s%03d", stadiumId, sections[i], seatNumber));
                seatParams.put("stadiumId", stadiumId);
                seatParams.put("section", sections[i]);
                seatParams.put("seatNumber", seatNumber);
                seatParams.put("price", prices[i]);
                seatParams.put("seatStatus", "Y");
                sqlSession.insert("kr.co.matchday.stadium.StadiumMapper.insertSeat", seatParams);
            }
        }
    }
}

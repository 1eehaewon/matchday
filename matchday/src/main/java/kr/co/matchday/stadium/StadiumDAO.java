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
    private SqlSession sqlSession; // MyBatis의 SqlSession을 주입받아 데이터베이스 작업을 수행

    // @Transactional 어노테이션은 이 메서드가 트랜잭션 내에서 실행됨을 의미
    @Transactional
    public void insertStadium(StadiumDTO stadiumDTO) {
        // 새 경기장 ID 생성
        String nextStadiumId = getNextStadiumId();
        stadiumDTO.setStadiumId(nextStadiumId); // 경기장 ID를 DTO에 설정
        // 경기장 정보를 데이터베이스에 삽입
        sqlSession.insert("kr.co.matchday.stadium.StadiumMapper.insertStadium", stadiumDTO);
        // 생성된 경기장 ID로 좌석 정보 삽입
        insertSeats(nextStadiumId);
    }

    // 다음 경기장 ID를 생성하는 메서드
    public String getNextStadiumId() {
        // 현재 최대 경기장 ID를 조회
        String maxId = sqlSession.selectOne("kr.co.matchday.stadium.StadiumMapper.getMaxStadiumId");
        if (maxId == null) {
            // 최초 경기장 ID가 없을 경우 기본값 반환
            return "stadium01";
        }
        // 현재 최대 ID에서 숫자를 추출하고 1 증가
        int nextId = Integer.parseInt(maxId.replace("stadium", "")) + 1;
        String newId;
        while (true) {
            // 새로운 ID 생성 (형식: stadiumXX)
            newId = String.format("stadium%02d", nextId);
            // 생성된 ID가 이미 존재하는지 확인
            String existingId = sqlSession.selectOne("kr.co.matchday.stadium.StadiumMapper.getStadiumById", newId);
            if (existingId == null) {
                break; // ID가 없으면 루프 종료
            }
            nextId++; // ID가 존재하면 숫자 증가
        }
        return newId; // 생성된 새로운 ID 반환
    }

    // 모든 경기장을 조회하는 메서드
    public List<StadiumDTO> getAllStadiums() {
        return sqlSession.selectList("kr.co.matchday.stadium.StadiumMapper.getAllStadiums");
    }

    // 좌석 정보를 삽입하는 비공식 메서드
    private void insertSeats(String stadiumId) {
        // 좌석 구역과 가격 설정
        String[] sections = {"N", "S", "E", "W"};
        int[] prices = {20000, 17000, 18000, 19000};
        int seatCount = 400; // 각 구역의 좌석 수

        for (int i = 0; i < sections.length; i++) {
            // 각 구역에 대해 좌석 정보를 삽입
            for (int seatNumber = 1; seatNumber <= seatCount; seatNumber++) {
                // 좌석 정보를 담을 맵 생성
                Map<String, Object> seatParams = new HashMap<>();
                seatParams.put("seatId", String.format("%s_%s%03d", stadiumId, sections[i], seatNumber)); // 좌석 ID 생성
                seatParams.put("stadiumId", stadiumId); // 경기장 ID
                seatParams.put("section", sections[i]); // 구역
                seatParams.put("seatNumber", seatNumber); // 좌석 번호
                seatParams.put("price", prices[i]); // 가격
                seatParams.put("seatStatus", "Y"); // 좌석 상태 (Y: 사용 가능)
                // 좌석 정보를 데이터베이스에 삽입
                sqlSession.insert("kr.co.matchday.stadium.StadiumMapper.insertSeat", seatParams);
            }
        }
    }
}

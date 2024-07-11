package kr.co.matchday.coupon;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Repository;

import kr.co.matchday.admin.CouponMasterDTO;

@Repository
public class CouponDAO {
	public CouponDAO() {
		System.out.println("CouponDAO() 객체 생성됨");
	}// end

	@Autowired
	SqlSession sqlSession;

	// 쿠폰내역 불러오기
	/*
	 * public List<CouponDTO> selectCouponList(String userid) { return
	 * sqlSession.selectList("mypage.selectCouponList", userid); }//
	 * selectCouponList() end
	 */
	
	public List<CouponDTO> selectReceivedCoupons(String userid) {
		return sqlSession.selectList("mypage.selectReceivedCoupons", userid);
	}

	public List<CouponMasterDTO> selectAvailableCoupons() {
		return sqlSession.selectList("mypage.selectAvailableCoupons");
	}

	// 쿠폰 다운로드 시 CouponDTO 삽입
    public void insertUserCoupon(CouponDTO couponDTO) {
        sqlSession.insert("mypage.insertUserCoupon", couponDTO);
    }

    // coupontypeid로 CouponMasterDTO 조회
    public CouponMasterDTO selectCouponByType(String coupontypeid) {
        return sqlSession.selectOne("mypage.selectCouponByType", coupontypeid);
    }
	
    // 이미 다운받은 쿠폰인지 확인
    public boolean checkUserDownloadedCoupon(String userid, String coupontypeid) {
        Map<String, Object> params = new HashMap<>();
        params.put("userid", userid);
        params.put("coupontypeid", coupontypeid);
        Integer count = sqlSession.selectOne("mypage.checkUserDownloadedCoupon", params);
        return count != null && count > 0;
    }
    
 // 사용자가 보유한 쿠폰 목록에서 만료된 쿠폰 제거
    public void deleteExpiredCoupons() {
        sqlSession.delete("mypage.deleteExpiredCoupons");
    }
}// class end

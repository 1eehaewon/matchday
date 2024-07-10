package kr.co.matchday.coupon;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
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
	
}// class end

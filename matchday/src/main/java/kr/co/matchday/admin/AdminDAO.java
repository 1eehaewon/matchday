package kr.co.matchday.admin;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAO {
	public AdminDAO() {
		System.out.println("AdminDAO() 객체 생성됨");
	}
	
	@Autowired
	SqlSession sqlSession;
	
	//회원정보 전체 불러오기
	public List<AdminDTO> selectAllUsers() {
        return sqlSession.selectList("admin.selectAllUsers"); 
    }
	
	//쿠폰등록하기
	public void insertCoupon(CouponMasterDTO couponMasterDto) {
        sqlSession.insert("admin.insertCoupon", couponMasterDto);
    }
	
	//관리자모드 쿠폰 목록 불러오기
	public List<CouponMasterDTO> selectAllCoupons(){
		return sqlSession.selectList("admin.selectAllCoupons");
	}
	
	 
	public CouponMasterDTO getCouponById(String coupontypeid) {
        return sqlSession.selectOne("admin.getCouponById", coupontypeid);
    }

    public int updateCoupon(CouponMasterDTO coupon) {
        return sqlSession.update("admin.updateCoupon", coupon);
    }

    public int deleteCoupon(String coupontypeid) {
    	return sqlSession.delete("admin.deleteCoupon", coupontypeid);
    }
    
    public List<PointMasterDTO> getPointCategories(){
    	return sqlSession.selectList("admin.getPointCategories");
    }
    
  //포인트등록하기
  	public void createPoint(PointMasterDTO pointMasterDto) {
          sqlSession.insert("admin.createPoint", pointMasterDto);
      }
  	
  	//포인트삭제
  	public int deletePoint(String pointcategoryid) {
    	return sqlSession.delete("admin.deletePoint", pointcategoryid);
    }
}//class end

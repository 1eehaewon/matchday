package kr.co.matchday.customer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CustomerDAO {

    // CustomerDAO 객체 생성 시 출력
    public CustomerDAO() {
        System.out.println("-----CustomerDAO() 객체 생성됨");
    }

    @Autowired
    SqlSession sqlSession;

    // 고객 문의 등록
    public int customerInsert(CustomerDTO customerDto) {
        return sqlSession.insert("Customer.insert", customerDto);
    }

    // 카테고리별 고객 문의 목록 조회
    public List<CustomerDTO> customerListByCategory(Map<String, Object> params) {
        return sqlSession.selectList("Customer.listByCategory", params);
    }

    // 카테고리별 고객 문의 수 조회
    public int customerCountByCategory(Map<String, Object> params) {
        return sqlSession.selectOne("Customer.countByCategory", params);
    }

    // 검색어를 포함한 고객 문의 목록 조회
    public List<CustomerDTO> searchInquiries(Map<String, Object> params) {
        return sqlSession.selectList("Customer.searchInquiries", params);
    }

    // 검색어를 포함한 고객 문의 수 조회
    public int countSearchInquiries(Map<String, Object> params) {
        return sqlSession.selectOne("Customer.countSearchInquiries", params);
    }

    // 고객 문의 상세 정보 조회
    public CustomerDTO customerDetail(int inquiryID) {
        return sqlSession.selectOne("Customer.customerDetail", inquiryID);
    }

    // 고객 문의 삭제
    public int deleteInquiry(int inquiryID) {
        return sqlSession.delete("Customer.deleteInquiry", inquiryID);
    }

    // 고객 문의 수정
    public int updateInquiry(CustomerDTO customerDto) {
        return sqlSession.update("Customer.updateInquiry", customerDto);
    }

    // 비밀번호 확인
    public boolean checkPassword(int inquiryID, int password) {
        CustomerDTO inquiry = customerDetail(inquiryID);
        if (inquiry != null) {
            System.out.println("DB Password: " + inquiry.getInqpasswd());
            System.out.println("Input Password: " + password);
            return inquiry.getInqpasswd() == password;
        }
        return false;
    }

    // 답변 등록
    public int replyInquiry(int inquiryID, String replyContent) {
        Map<String, Object> params = new HashMap<>();
        params.put("inquiryID", inquiryID);
        params.put("replyContent", replyContent);
        return sqlSession.update("Customer.replyInquiry", params);
    }
}

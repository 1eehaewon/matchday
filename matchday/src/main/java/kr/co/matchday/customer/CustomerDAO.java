package kr.co.matchday.customer;

import java.util.List;

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
    public List<CustomerDTO> customerListByCategory(CustomerDTO params) {
        return sqlSession.selectList("Customer.listByCategory", params);
    }

    // 카테고리별 고객 문의 수 조회
    public int customerCountByCategory(CustomerDTO params) {
        return sqlSession.selectOne("Customer.countByCategory", params);
    }

    // 검색어를 포함한 고객 문의 목록 조회
    public List<CustomerDTO> searchInquiries(CustomerDTO params) {
        return sqlSession.selectList("Customer.searchInquiries", params);
    }

    // 검색어를 포함한 고객 문의 수 조회
    public int countSearchInquiries(CustomerDTO params) {
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
    public boolean checkPassword(CustomerDTO params) {
        return sqlSession.selectOne("Customer.checkPassword", params);
    }

    // 답변 등록
    public int replyInquiry(CustomerDTO customerDto) {
        return sqlSession.update("Customer.replyInquiry", customerDto);
    }

    // FAQ 카테고리의 글을 가져오는 메서드 추가
    public List<CustomerDTO> getFaqList(CustomerDTO params) {
        return sqlSession.selectList("Customer.getFaqList", params);
    }

    // FAQ 삽입 메서드 추가
    public int insertFaq(CustomerDTO customerDto) {
        return sqlSession.insert("Customer.insertFaq", customerDto);
    }

    // FAQ 수정 메서드 추가
    public int updateFaq(CustomerDTO customerDto) {
        return sqlSession.update("Customer.updateFaq", customerDto);
    }

    // FAQ 삭제 메서드 추가
    public int deleteFaq(int inquiryID) {
        return sqlSession.delete("Customer.deleteFaq", inquiryID);
    }
}

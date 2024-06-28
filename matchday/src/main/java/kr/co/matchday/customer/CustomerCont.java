package kr.co.matchday.customer;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/CustomerService")
public class CustomerCont {

    // Logger 설정
    private static final Logger logger = LoggerFactory.getLogger(CustomerCont.class);

    @Autowired
    private CustomerDAO customerDao;

    // 고객 문의 목록 페이지
    @GetMapping("/CustomerPage")
    public ModelAndView customerPage(@RequestParam(defaultValue = "all") String category,
                                     @RequestParam(defaultValue = "1") int page,
                                     @RequestParam(required = false) String col,
                                     @RequestParam(required = false) String word) {
        int pageSize = 10; // 페이지 당 게시글 수
        int start = (page - 1) * pageSize;

        // 검색 및 페이징을 위한 파라미터 설정
        Map<String, Object> params = new HashMap<>();
        params.put("category", category);
        params.put("start", start);
        params.put("pageSize", pageSize);
        params.put("col", col);
        params.put("word", word);

        List<CustomerDTO> inquiryList;
        int totalCount;

        // 검색어가 있는 경우와 없는 경우를 구분하여 처리
        if (word != null && !word.trim().isEmpty()) {
            inquiryList = customerDao.searchInquiries(params);
            totalCount = customerDao.countSearchInquiries(params);
        } else {
            inquiryList = customerDao.customerListByCategory(params);
            totalCount = customerDao.customerCountByCategory(params);
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 날짜 포맷 변경
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (CustomerDTO inquiry : inquiryList) {
            String formattedDate = dateFormat.format(inquiry.getCreatedDate());
            inquiry.setFormattedCreatedDate(formattedDate);
        }

        // ModelAndView 객체 생성 및 데이터 설정
        ModelAndView mav = new ModelAndView("CustomerService/CustomerPage");
        mav.addObject("inquiryList", inquiryList);
        mav.addObject("currentPage", page);
        mav.addObject("totalPages", totalPages);
        mav.addObject("category", category);
        mav.addObject("col", col);
        mav.addObject("word", word);
        return mav;
    }

    // 고객 문의 작성 폼
    @GetMapping("/CustomerForm")
    public String customerForm() {
        return "CustomerService/CustomerForm";
    }

    // 고객 문의 등록 처리
    @PostMapping("/insert")
    public ModelAndView customerFormInsert(CustomerDTO customerDto, 
                                           @RequestParam("category") String category, 
                                           HttpSession session) throws Exception {
        // 테스트용 사용자 ID 설정 (실제 구현 시 세션에서 가져와야 함)
        String userID = "Test";
        customerDto.setUserID(userID);
        customerDto.setCreatedDate(new Date());
        
        // 카테고리에 따른 boardType 설정
        int boardType;
        switch (category) {
            case "goods":
                boardType = 1;
                break;
            case "match":
                boardType = 2;
                break;
            case "delivery":
                boardType = 3;
                break;
            case "patment":
                boardType = 4;
                break;
            default:
                boardType = 0; // 기본값 설정
        }
        customerDto.setBoardType(boardType);
        
        // 임시 비밀번호 설정 (실제 구현 시 사용자 입력 받아야 함)
        customerDto.setInqpasswd(1234);
        
        // 답변 상태 초기 설정
        if (customerDto.getIsReplyHandled() == null) {
            customerDto.setIsReplyHandled("답변처리중");
        }

        // 문의 등록 실행
        int cnt = customerDao.customerInsert(customerDto);

        // 결과에 따른 뷰 및 메시지 설정
        ModelAndView mav = new ModelAndView("redirect:/CustomerService/CustomerPage");
        if (cnt > 0) {
            mav.addObject("msg", "문의가 성공적으로 등록되었습니다.");
        } else {
            mav.setViewName("CustomerService/CustomerForm");
            mav.addObject("msg", "문의 등록에 실패하였습니다. 다시 시도해 주세요.");
        }
        return mav;
    }

    // 고객 문의 상세 조회
    @GetMapping("/CustomerDetail/{inquiryID}")
    public ModelAndView detail(@PathVariable int inquiryID) {
        ModelAndView mav = new ModelAndView("CustomerService/CustomerDetail");
        CustomerDTO inquiry = customerDao.customerDetail(inquiryID);
        mav.addObject("inquiry", inquiry);
        return mav;
    }
    
    // 고객 문의 삭제 처리
    @PostMapping("/delete/{inquiryID}")
    public ModelAndView deleteInquiry(@PathVariable("inquiryID") int inquiryID) {
        int result = customerDao.deleteInquiry(inquiryID);
        ModelAndView mav = new ModelAndView("redirect:/CustomerService/CustomerPage");
        if (result > 0) {
            mav.addObject("msg", "문의글이 성공적으로 삭제되었습니다.");
        } else {
            mav.addObject("msg", "문의글 삭제에 실패하였습니다.");
        }
        return mav;
    }
    
    // 비밀번호 확인
    @PostMapping("/checkPassword")
    @ResponseBody
    public Map<String, Boolean> checkPassword(@RequestParam("inquiryID") int inquiryID, 
                                              @RequestParam("password") String password) {
        Map<String, Boolean> response = new HashMap<>();
        try {
            int passwordInt = Integer.parseInt(password);
            boolean isValid = customerDao.checkPassword(inquiryID, passwordInt);
            response.put("valid", isValid);
        } catch (NumberFormatException e) {
            response.put("valid", false);
        }
        return response;
    }

    // 문의글 수정 처리
    @PostMapping("/update")
    public String updateInquiry(@ModelAttribute CustomerDTO customerDto, RedirectAttributes redirectAttributes) {
        try {
            int result = customerDao.updateInquiry(customerDto);
            if (result > 0) {
                redirectAttributes.addFlashAttribute("message", "문의글이 성공적으로 수정되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("error", "문의글 수정에 실패하였습니다.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "문의글 수정 중 오류가 발생하였습니다.");
        }
        return "redirect:/CustomerService/CustomerPage";
    }

    
    // 관리자 답변 추가 처리
    @PostMapping("/addReply")
    @ResponseBody
    public Map<String, Object> addReply(@RequestParam int inquiryID, @RequestParam String replyContent) {
        Map<String, Object> response = new HashMap<>();
        try {
            CustomerDTO inquiry = customerDao.customerDetail(inquiryID);
            // 이미 답변이 있는 경우 에러 메시지 반환
            if (inquiry.getInquiryReply() != null && !inquiry.getInquiryReply().isEmpty()) {
                response.put("status", "error");
                response.put("message", "이미 등록된 답변이 있습니다.");
                return response;
            }

            // 답변 등록
            int result = customerDao.replyInquiry(inquiryID, replyContent);
            if (result > 0) {
                response.put("status", "success");
            } else {
                response.put("status", "error");
                response.put("message", "답변 등록에 실패하였습니다.");
            }
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "답변 등록 중 오류가 발생하였습니다.");
        }
        return response;
    }
    
    // 고객 FAQ 페이지 호출
    @GetMapping("/CustomerFAQ")
    public String customerFAQ() {
        logger.info("CustomerFAQ 페이지 호출됨");
        return "CustomerService/CustomerFAQ"; 
    }
    

}

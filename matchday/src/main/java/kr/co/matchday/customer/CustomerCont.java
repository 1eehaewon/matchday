package kr.co.matchday.customer;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.order.OrderDTO;
import kr.co.matchday.tickets.TicketsDTO;

@Controller
@RequestMapping("/customerService")
public class CustomerCont {

    // Logger 설정
    private static final Logger logger = LoggerFactory.getLogger(CustomerCont.class);

    @Autowired
    private CustomerDAO customerDao;
    
    @Autowired
    private JavaMailSender mailSender;

    // 생성자
    public CustomerCont() {
        System.out.println("-----CustomerCont() 호출됨");
    }

    // 고객 문의 페이지를 반환하는 메서드
    @GetMapping("/customerPage")
    public ModelAndView customerPage(@RequestParam(defaultValue = "all") String category,
                                     @RequestParam(defaultValue = "1") int page,
                                     @RequestParam(required = false) String col,
                                     @RequestParam(required = false) String word) {
        int pageSize = 10; // 페이지 당 게시글 수
        int start = (page - 1) * pageSize; // 페이징 시작 위치

        // 검색 및 페이징에 필요한 파라미터를 DTO에 설정
        CustomerDTO params = new CustomerDTO();
        params.setCategory(category);
        params.setStart(start);
        params.setPageSize(pageSize);
        params.setCol(col);
        params.setWord(word);

        List<CustomerDTO> inquiryList; // 문의 목록
        int totalCount; // 총 문의 수

        // 검색어가 있는 경우와 없는 경우에 따라 다른 DAO 메서드 호출
        if (word != null && !word.trim().isEmpty()) {
            inquiryList = customerDao.searchInquiries(params); // 검색어가 있는 경우
            totalCount = customerDao.countSearchInquiries(params); // 검색어에 해당하는 총 문의 수
        } else {
            inquiryList = customerDao.customerListByCategory(params); // 검색어가 없는 경우
            totalCount = customerDao.customerCountByCategory(params); // 해당 카테고리의 총 문의 수
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize); // 총 페이지 수 계산

        // 날짜 포맷팅
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (CustomerDTO inquiry : inquiryList) {
            String formattedDate = dateFormat.format(inquiry.getCreatedDate());
            inquiry.setFormattedCreatedDate(formattedDate);
        }

        // ModelAndView 객체 생성 및 데이터를 추가
        ModelAndView mav = new ModelAndView("customerService/customerPage");
        mav.addObject("inquiryList", inquiryList);
        mav.addObject("currentPage", page);
        mav.addObject("totalPages", totalPages);
        mav.addObject("category", category);
        mav.addObject("col", col);
        mav.addObject("word", word);
        return mav;
    }

    // 고객 문의 폼 페이지를 반환하는 메서드
    @GetMapping("/customerForm")
    public ModelAndView customerForm(HttpSession session) {
        ModelAndView mav = new ModelAndView("customerService/customerForm");

        // 임의의 데이터로 matchList와 productList 생성
        List<CustomerDTO> matchList = new ArrayList<>();
        CustomerDTO match1 = new CustomerDTO();
        match1.setInquiryID(1);
        match1.setTitle("축구 경기 1");
        match1.setFormattedCreatedDate("2023-06-01");
        matchList.add(match1);

        CustomerDTO match2 = new CustomerDTO();
        match2.setInquiryID(2);
        match2.setTitle("축구 경기 2");
        match2.setFormattedCreatedDate("2023-06-15");
        matchList.add(match2);

        List<CustomerDTO> productList = new ArrayList<>();
        CustomerDTO product1 = new CustomerDTO();
        product1.setInquiryID(1);
        product1.setTitle("상품 1");
        product1.setFormattedCreatedDate("2023-06-05");
        productList.add(product1);

        CustomerDTO product2 = new CustomerDTO();
        product2.setInquiryID(2);
        product2.setTitle("상품 2");
        product2.setFormattedCreatedDate("2023-06-20");
        productList.add(product2);

        mav.addObject("matchList", matchList); // 경기에 대한 문의 리스트 추가
        mav.addObject("productList", productList); // 상품에 대한 문의 리스트 추가
        mav.addObject("userID", session.getAttribute("userID")); // 세션에서 userID를 가져와서 추가

        return mav;
    }

    // 고객 문의를 등록하는 메서드
    @PostMapping("/insert")
    public ModelAndView customerFormInsert(CustomerDTO customerDto, 
                                           @RequestParam("category") String category, 
                                           HttpSession session) throws Exception {
        String userID = (String) session.getAttribute("userID");
        customerDto.setUserID(userID); // 세션에서 가져온 사용자 ID 설정
        customerDto.setCreatedDate(new Date());

        // 선택된 카테고리를 그대로 저장
        customerDto.setBoardType(category);

        if (customerDto.getIsReplyHandled() == null) {
            customerDto.setIsReplyHandled("답변처리중");
        }

        int cnt = customerDao.customerInsert(customerDto); // 문의 등록

        ModelAndView mav = new ModelAndView("redirect:/customerService/customerPage");
        if (cnt > 0) {
            mav.addObject("msg", "문의가 성공적으로 등록되었습니다.");
        } else {
            mav.setViewName("customerService/customerForm");
            mav.addObject("msg", "문의 등록에 실패하였습니다. 다시 시도해 주세요.");
        }
        return mav;
    }

    // 문의 상세 페이지를 반환하는 메서드
    @GetMapping("/customerDetail/{inquiryID}")
    public ModelAndView detail(@PathVariable int inquiryID) {
        ModelAndView mav = new ModelAndView("customerService/customerDetail");
        CustomerDTO inquiry = customerDao.customerDetail(inquiryID); // 문의 상세 정보 가져오기
        mav.addObject("inquiry", inquiry); // ModelAndView에 문의 정보 추가
        return mav;
    }

    // 문의 삭제를 처리하는 메서드
    @PostMapping("/delete/{inquiryID}")
    public ModelAndView deleteInquiry(@PathVariable("inquiryID") int inquiryID) {
        int result = customerDao.deleteInquiry(inquiryID); // 문의 삭제
        ModelAndView mav = new ModelAndView("redirect:/customerService/customerPage");
        if (result > 0) {
            mav.addObject("msg", "문의글이 성공적으로 삭제되었습니다.");
        } else {
            mav.addObject("msg", "문의글 삭제에 실패하였습니다.");
        }
        return mav;
    }

    // 비밀번호 확인을 처리하는 메서드
    @PostMapping("/checkPassword")
    @ResponseBody
    public Map<String, Boolean> checkPassword(@RequestParam("inquiryID") int inquiryID, @RequestParam("password") int password) {
        Map<String, Boolean> response = new HashMap<>();
        try {
            CustomerDTO customerDto = new CustomerDTO();
            customerDto.setInquiryID(inquiryID);
            customerDto.setInqpasswd(password);
            boolean isValid = customerDao.checkPassword(customerDto); // 비밀번호 확인
            response.put("valid", isValid);
        } catch (NumberFormatException e) {
            response.put("valid", false);
        }
        return response;
    }

    // 문의 수정을 처리하는 메서드
    @PostMapping("/update")
    public String updateInquiry(@ModelAttribute CustomerDTO customerDto, @RequestParam("category") String category, RedirectAttributes redirectAttributes) {
        try {
            customerDto.setBoardType(category); // 카테고리 설정
            int result = customerDao.updateInquiry(customerDto); // 문의 수정
            if (result > 0) {
                redirectAttributes.addFlashAttribute("message", "문의글이 성공적으로 수정되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("error", "문의글 수정에 실패하였습니다.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "문의글 수정 중 오류가 발생하였습니다.");
        }
        return "redirect:/customerService/customerPage";
    }
    
    // 고객 답변을 추가하는 메서드
    @PostMapping("/addReply")
    @ResponseBody
    public Map<String, Object> addReply(@RequestParam int inquiryID, @RequestParam String inquiryReply) {
        Map<String, Object> response = new HashMap<>();
        try {
            CustomerDTO inquiry = customerDao.customerDetail(inquiryID); // 문의 상세 정보 가져오기
            // 이미 답변이 있는지 확인
            if (inquiry.getInquiryReply() != null && !inquiry.getInquiryReply().isEmpty()) {
                response.put("status", "error");
                response.put("message", "이미 등록된 답변이 있습니다.");
                return response;
            }

            inquiry.setInquiryReply(inquiryReply); // 답변 설정
            inquiry.setReplyDate(new Date()); // 답변 시간을 현재 시간으로 설정
            int result = customerDao.replyInquiry(inquiry); // 답변 등록

            if (result > 0) {
                response.put("status", "success");

                // 이메일 발송
                String email = customerDao.getUserEmail(inquiry.getUserID());
                if (email != null && !email.isEmpty()) {
                    sendEmail(email, inquiry.getTitle(), inquiryReply); // 이메일 발송
                } else {
                    response.put("status", "error");
                    response.put("message", "유효한 이메일 주소를 찾을 수 없습니다.");
                }
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

    // 이메일 발송 메서드
    private void sendEmail(String to, String inquiryTitle, String inquiryReply) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to); // 수신자 설정
            helper.setSubject("고객님의 문의에 대한 답변이 등록되었습니다."); // 제목 설정
            
            // 이메일 본문 내용 설정
            StringBuilder content = new StringBuilder();
            content.append("<p>안녕하세요, 고객님.</p>");
            content.append("<p>고객님께서 문의하신 내용에 대한 답변이 등록되었습니다.</p>");
            content.append("<p><b>문의 제목:</b> ").append(inquiryTitle).append("</p>");
            content.append("<p><b>답변 내용:</b> ").append(inquiryReply).append("</p>");
            content.append("<p>더 궁금한 사항이 있으시면 언제든지 문의해 주세요.</p>");
            content.append("<p>감사합니다.</p>");

            helper.setText(content.toString(), true); // HTML 형식으로 설정
            mailSender.send(message); // 이메일 발송
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // FAQ 작성 폼 페이지를 반환하는 메서드
    @GetMapping("/customerFaqForm")
    public ModelAndView customerFaqForm() {
        ModelAndView mav = new ModelAndView("customerService/customerFaqForm");
        mav.addObject("faq", new CustomerDTO()); // 빈 FAQ DTO를 추가하여 폼 페이지로 전달
        return mav;
    }

    // FAQ를 삽입하는 메서드
    @PostMapping("/insertFaq")
    public String insertFaq(@ModelAttribute CustomerDTO customerDto, RedirectAttributes redirectAttributes) {
        customerDto.setBoardType("FAQ");
        customerDto.setUserID("webmaster"); // userID를 임의로 설정
        int result = customerDao.insertFaq(customerDto); // FAQ 삽입
        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "FAQ가 성공적으로 등록되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "FAQ 등록에 실패하였습니다.");
        }
        return "redirect:/customerService/customerFaq";
    }

    // FAQ 상세 페이지로 이동
    @GetMapping("/customerFaqDetail/{inquiryID}")
    public ModelAndView customerFaqDetail(@PathVariable int inquiryID) {
        ModelAndView mav = new ModelAndView("customerService/customerFaqDetail");
        CustomerDTO faq = customerDao.customerDetail(inquiryID); // FAQ 상세 정보 가져오기
        mav.addObject("faq", faq); // ModelAndView에 FAQ 정보 추가
        return mav;
    }

    // FAQ 수정 폼 페이지를 반환하는 메서드
    @GetMapping("/customerFaqForm/{inquiryID}")
    public ModelAndView customerFaqEditForm(@PathVariable int inquiryID) {
        ModelAndView mav = new ModelAndView("customerService/customerFaqForm");
        CustomerDTO faq = customerDao.customerDetail(inquiryID); // 수정할 FAQ 정보 가져오기
        mav.addObject("faq", faq); // ModelAndView에 FAQ 정보 추가
        return mav;
    }

    // FAQ 수정을 처리하는 메서드
    @PostMapping("/updateFaq")
    public String updateFaq(@ModelAttribute CustomerDTO customerDto, RedirectAttributes redirectAttributes) {
        try {
            customerDto.setBoardType("FAQ"); // 게시판 타입 설정
            int result = customerDao.updateFaq(customerDto); // FAQ 수정
            if (result > 0) {
                redirectAttributes.addFlashAttribute("message", "FAQ가 성공적으로 수정되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("error", "FAQ 수정에 실패하였습니다.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "FAQ 수정 중 오류가 발생하였습니다.");
        }
        return "redirect:/customerService/customerFaq";
    }

    // FAQ 삭제를 처리하는 메서드
    @PostMapping("/deleteFaq/{inquiryID}")
    public String deleteFaq(@PathVariable int inquiryID, RedirectAttributes redirectAttributes) {
        int result = customerDao.deleteFaq(inquiryID); // FAQ 삭제
        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "FAQ가 성공적으로 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "FAQ 삭제에 실패하였습니다.");
        }
        return "redirect:/customerService/customerFaq";
    }

    // 이미지 업로드를 처리하는 메서드
    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("file") MultipartFile file) {
        String imageUrl = "";
        try {
            // 프로젝트 경로를 기반으로 저장 경로 설정
            String uploadDir = new File("src/main/webapp/storage/customerimg").getAbsolutePath();
            String fileName = file.getOriginalFilename();
            File dest = new File(uploadDir + File.separator + fileName);
            file.transferTo(dest); // 파일 저장

            // 이미지 URL 설정 (웹 서버의 경로로 맞춰야 함)
            imageUrl = "/storage/customerimg/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return imageUrl;
    }

    // FAQ 페이지를 반환하는 메서드
    @GetMapping("/customerFaq")
    public ModelAndView customerFaq() {
        CustomerDTO params = new CustomerDTO();
        params.setBoardType("FAQ");

        List<CustomerDTO> faqList = customerDao.getFaqList(params); // FAQ 목록 가져오기

        ModelAndView mav = new ModelAndView("customerService/customerFaq");
        mav.addObject("faqList", faqList); // ModelAndView에 FAQ 목록 추가
        return mav;
    }
    
    // 구매 내역 팝업을 반환하는 메서드
    @GetMapping("/purchaseHistoryPopup")
    public ModelAndView purchaseHistoryPopup(HttpSession session) {
        String userID = (String) session.getAttribute("userID");
        List<TicketsDTO> purchaseList = customerDao.getPurchaseHistory(userID); // 구매 내역 가져오기
        List<OrderDTO> orderList = customerDao.getPurchasedOrders(userID); // 주문 내역 가져오기
        
        ModelAndView mav = new ModelAndView("customerService/purchaseHistoryPopup");
        mav.addObject("purchaseList", purchaseList); // ModelAndView에 구매 내역 추가
        mav.addObject("orderList", orderList); // ModelAndView에 주문 내역 추가
        return mav;
    }

}

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

    private static final Logger logger = LoggerFactory.getLogger(CustomerCont.class);

    @Autowired
    private CustomerDAO customerDao;
    
    @Autowired
    private JavaMailSender mailSender;

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
        int start = (page - 1) * pageSize;

        // 검색 및 페이징에 필요한 파라미터를 DTO에 설정
        CustomerDTO params = new CustomerDTO();
        params.setCategory(category);
        params.setStart(start);
        params.setPageSize(pageSize);
        params.setCol(col);
        params.setWord(word);

        List<CustomerDTO> inquiryList;
        int totalCount;

        if (word != null && !word.trim().isEmpty()) {
            inquiryList = customerDao.searchInquiries(params);
            totalCount = customerDao.countSearchInquiries(params);
        } else {
            inquiryList = customerDao.customerListByCategory(params);
            totalCount = customerDao.customerCountByCategory(params);
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

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

        mav.addObject("matchList", matchList);
        mav.addObject("productList", productList);
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

        int cnt = customerDao.customerInsert(customerDto);

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
        CustomerDTO inquiry = customerDao.customerDetail(inquiryID);
        mav.addObject("inquiry", inquiry);
        return mav;
    }

    // 문의 삭제를 처리하는 메서드
    @PostMapping("/delete/{inquiryID}")
    public ModelAndView deleteInquiry(@PathVariable("inquiryID") int inquiryID) {
        int result = customerDao.deleteInquiry(inquiryID);
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
            boolean isValid = customerDao.checkPassword(customerDto);
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
            int result = customerDao.updateInquiry(customerDto);
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
    
    /*
    @PostMapping("/addReply")
    @ResponseBody
    public Map<String, Object> addReply(@RequestParam int inquiryID, @RequestParam String inquiryReply) {
        Map<String, Object> response = new HashMap<>();
        Logger logger = LoggerFactory.getLogger(CustomerCont.class);

        logger.info("addReply 메서드 시작");
        System.out.println("addReply 메서드 시작");

        try {
            CustomerDTO inquiry = customerDao.customerDetail(inquiryID);
            if (inquiry.getInquiryReply() != null && !inquiry.getInquiryReply().isEmpty()) {
                response.put("status", "error");
                response.put("message", "이미 등록된 답변이 있습니다.");
                return response;
            }

            inquiry.setInquiryReply(inquiryReply);
            inquiry.setReplyDate(new Date()); // 답변 시간을 현재 시간으로 설정
            int result = customerDao.replyInquiry(inquiry);

            if (result > 0) {
                response.put("status", "success");
                logger.info("답변이 성공적으로 등록되었습니다.");
                System.out.println("답변이 성공적으로 등록되었습니다.");

                // 답변 등록 성공 시 이메일 발송
                String email = customerDao.getUserEmail(inquiry.getUserID());
                logger.info("이메일 발송 대상: " + email);
                System.out.println("이메일 발송 대상: " + email);

                if (email != null && !email.isEmpty()) {
                    String recipient = email;
                    String subject = "고객님의 문의에 대한 답변이 등록되었습니다.";
                    String content = "<p>안녕하세요, 고객님.</p>" +
                                     "<p>문의하신 내용에 대한 답변이 등록되었습니다.</p>" +
                                     "<p>답변 내용: " + inquiryReply + "</p>";

                    try {
                        String mailserver = "mw-002.cafe24.com"; // cafe24 메일 서버
                        Properties props = new Properties();
                        props.put("mail.smtp.host", mailserver);
                        props.put("mail.smtp.auth", "true");
                        props.put("mail.smtp.port", "587"); // 필요시 수정
                        props.put("mail.smtp.starttls.enable", "true"); // TLS 사용

                        javax.mail.Authenticator myAuth = new MyAuthenticator();
                        Session sess = Session.getInstance(props, myAuth);
                        sess.setDebug(true); // Enable debug mode

                        Message msg = new MimeMessage(sess);
                        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
                        msg.setFrom(new InternetAddress("webmaster@itwill.co.kr"));
                        msg.setSubject(subject);
                        msg.setContent(content, "text/html; charset=UTF-8");
                        msg.setSentDate(new Date());

                        logger.info("이메일 발송 준비 완료. 발송 시작.");
                        System.out.println("이메일 발송 준비 완료. 발송 시작.");
                        Transport.send(msg);
                        logger.info("Email sent successfully to " + recipient);
                        System.out.println("Email sent successfully to " + recipient);
                    } catch (MessagingException e) {
                        logger.error("MessagingException: ", e);
                        System.err.println("MessagingException: " + e);
                        response.put("status", "error");
                        response.put("message", "답변은 등록되었으나 이메일 발송에 실패하였습니다.");
                    } catch (Exception e) {
                        logger.error("Exception: ", e);
                        System.err.println("Exception: " + e);
                        response.put("status", "error");
                        response.put("message", "예기치 않은 오류로 이메일 발송에 실패하였습니다.");
                    }
                } else {
                    logger.error("유효한 이메일 주소를 찾을 수 없습니다.");
                    System.err.println("유효한 이메일 주소를 찾을 수 없습니다.");
                    response.put("status", "error");
                    response.put("message", "유효한 이메일 주소를 찾을 수 없습니다.");
                }
            } else {
                response.put("status", "error");
                response.put("message", "답변 등록에 실패하였습니다.");
            }
        } catch (Exception e) {
            logger.error("Exception: ", e);
            System.err.println("Exception: " + e);
            response.put("status", "error");
            response.put("message", "답변 등록 중 오류가 발생하였습니다.");
        }
        return response;
    }
    */
    
    @PostMapping("/addReply")
    @ResponseBody
    public Map<String, Object> addReply(@RequestParam int inquiryID, @RequestParam String inquiryReply) {
        Map<String, Object> response = new HashMap<>();
        try {
            CustomerDTO inquiry = customerDao.customerDetail(inquiryID);
            if (inquiry.getInquiryReply() != null && !inquiry.getInquiryReply().isEmpty()) {
                response.put("status", "error");
                response.put("message", "이미 등록된 답변이 있습니다.");
                return response;
            }

            inquiry.setInquiryReply(inquiryReply);
            inquiry.setReplyDate(new Date()); // 답변 시간을 현재 시간으로 설정
            int result = customerDao.replyInquiry(inquiry);

            if (result > 0) {
                response.put("status", "success");

                // 이메일 발송
                String email = customerDao.getUserEmail(inquiry.getUserID());
                if (email != null && !email.isEmpty()) {
                    sendEmail(email, inquiry.getTitle(), inquiryReply);
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

    private void sendEmail(String to, String inquiryTitle, String inquiryReply) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("고객님의 문의에 대한 답변이 등록되었습니다.");
            
            StringBuilder content = new StringBuilder();
            content.append("<p>안녕하세요, 고객님.</p>");
            content.append("<p>고객님께서 문의하신 내용에 대한 답변이 등록되었습니다.</p>");
            content.append("<p><b>문의 제목:</b> ").append(inquiryTitle).append("</p>");
            content.append("<p><b>답변 내용:</b> ").append(inquiryReply).append("</p>");
            content.append("<p>더 궁금한 사항이 있으시면 언제든지 문의해 주세요.</p>");
            content.append("<p>감사합니다.</p>");

            helper.setText(content.toString(), true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // FAQ 작성 폼 페이지를 반환하는 메서드
    @GetMapping("/customerFaqForm")
    public ModelAndView customerFaqForm() {
        ModelAndView mav = new ModelAndView("customerService/customerFaqForm");
        mav.addObject("faq", new CustomerDTO());
        return mav;
    }

    // FAQ를 삽입하는 메서드
    @PostMapping("/insertFaq")
    public String insertFaq(@ModelAttribute CustomerDTO customerDto, RedirectAttributes redirectAttributes) {
        customerDto.setBoardType("FAQ");
        customerDto.setUserID("webmaster"); // userID를 임의로 설정
        int result = customerDao.insertFaq(customerDto);
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
        CustomerDTO faq = customerDao.customerDetail(inquiryID);
        mav.addObject("faq", faq);
        return mav;
    }

    // FAQ 수정 폼 페이지를 반환하는 메서드
    @GetMapping("/customerFaqForm/{inquiryID}")
    public ModelAndView customerFaqEditForm(@PathVariable int inquiryID) {
        ModelAndView mav = new ModelAndView("customerService/customerFaqForm");
        CustomerDTO faq = customerDao.customerDetail(inquiryID);
        mav.addObject("faq", faq);
        return mav;
    }

    // FAQ 수정을 처리하는 메서드
    @PostMapping("/updateFaq")
    public String updateFaq(@ModelAttribute CustomerDTO customerDto, RedirectAttributes redirectAttributes) {
        try {
            customerDto.setBoardType("FAQ");
            int result = customerDao.updateFaq(customerDto);
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
        int result = customerDao.deleteFaq(inquiryID);
        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "FAQ가 성공적으로 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "FAQ 삭제에 실패하였습니다.");
        }
        return "redirect:/customerService/customerFaq";
    }

    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("file") MultipartFile file) {
        String imageUrl = "";
        try {
            // 프로젝트 경로를 기반으로 저장 경로 설정
            String uploadDir = new File("src/main/webapp/storage/customerimg").getAbsolutePath();
            String fileName = file.getOriginalFilename();
            File dest = new File(uploadDir + File.separator + fileName);
            file.transferTo(dest);

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

        List<CustomerDTO> faqList = customerDao.getFaqList(params);

        ModelAndView mav = new ModelAndView("customerService/customerFaq");
        mav.addObject("faqList", faqList);
        return mav;
    }
    
    @GetMapping("/purchaseHistoryPopup")
    public ModelAndView purchaseHistoryPopup(HttpSession session) {
        String userID = (String) session.getAttribute("userID");
        List<TicketsDTO> purchaseList = customerDao.getPurchaseHistory(userID);
        List<OrderDTO> orderList = customerDao.getPurchasedOrders(userID);
        
        ModelAndView mav = new ModelAndView("customerService/purchaseHistoryPopup");
        mav.addObject("purchaseList", purchaseList);
        mav.addObject("orderList", orderList);
        return mav;
    }


}

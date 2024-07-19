package kr.co.matchday.review;

import java.io.File;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;

@Controller
@RequestMapping("/review")
public class ReviewCont {

    public ReviewCont() {
        System.out.println("-----ReviewCont() 객체 생성됨");
    }

    @Autowired
    private ReviewDAO reviewDao;

    @Autowired
    private GoodsDAO goodsDao;

    @GetMapping("/write")
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto, Model model, HttpSession session) {
        // 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }

        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        return "review/write";
    }

    @GetMapping("/list")
    public String list(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }

        List<ReviewDTO> reviewList = reviewDao.list();
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("goodsList", goodsList);

        return "review/list";
    }

    @PostMapping("/insert")
    @ResponseBody
    public String insert(@ModelAttribute ReviewDTO reviewDto, HttpSession session,
                         @RequestParam("img") List<MultipartFile> imgs,
                         HttpServletRequest req) {
        // 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }

        // 기타 필요한 정보 설정 (userid, matchid, goodsid)
        reviewDto.setUserid(userid);
        reviewDto.setGoodsid(req.getParameter("goodsid"));

        // 리뷰 날짜 설정
        reviewDto.setReviewdate(new Timestamp(System.currentTimeMillis())); // Timestamp로 설정

        // grantedpoints 설정 (필요한 로직에 따라 설정)
        reviewDto.setGrantedpoints(100); // 예시로 100 포인트 설정

        // 업로드 파일 처리
        String filenames = "-";
        long totalFilesize = 0;

        for (MultipartFile img : imgs) {
            if (img.getSize() > 0 && !img.isEmpty()) { // 파일이 존재한다면
                long filesize = img.getSize();
                totalFilesize += filesize;

                try {
                    String originalFilename = img.getOriginalFilename();
                    String filename = originalFilename;

                    ServletContext application = req.getSession().getServletContext();
                    String basePath = application.getRealPath("/storage/review");

                    File file = new File(basePath, filename);
                    int i = 1;
                    while (file.exists()) {
                        int lastDot = originalFilename.lastIndexOf(".");
                        filename = originalFilename.substring(0, lastDot) + "_" + i + originalFilename.substring(lastDot);
                        file = new File(basePath, filename);
                        i++;
                    }

                    img.transferTo(file);

                    if (filenames.equals("-")) {
                        filenames = filename;
                    } else {
                        filenames += "," + filename;
                    }

                } catch (Exception e) {
                    System.out.println(e);
                }
            }
        }

        reviewDto.setFilename(filenames);
        reviewDto.setFilesize(totalFilesize);

        // 리뷰 삽입
        reviewDao.insert(reviewDto);

        // 포인트 히스토리 추가
        reviewDao.insertPointHistory(userid, 100, "리뷰 이벤트 포인트 적립");

        return "success"; // 성공 시 "success" 메시지 반환
    }

    @GetMapping("/filename/{reviewid}")
    public String getFilename(@PathVariable String reviewid) {
        return reviewDao.filename(reviewid);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam("reviewid") String reviewid, HttpServletRequest req) {
        String filename = reviewDao.filename(reviewid); // 삭제하고자 하는 파일명 가져오기

        if (filename != null && !filename.equals("-")) { // 첨부된 파일 삭제하기
            ServletContext application = req.getSession().getServletContext();
            String path = application.getRealPath("/storage/review");
            File file = new File(path + "/" + filename);
            if (file.exists()) {
                file.delete();
            }
        }

        reviewDao.reviewdelete(reviewid); // 테이블 행 삭제
        return "success";
    }
}

package kr.co.matchday.notice;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/notice")
public class NoticeCont {

    @Autowired
    private NoticeDAO noticeDao;

    public NoticeCont() {
        System.out.println("-----NoticeCont() 객체생성됨");
    }

    @GetMapping("/write")
    public String write() {
        return "notice/write";
    }

    @PostMapping("/insert")
    public String insert(@ModelAttribute NoticeDTO noticeDto) {
        noticeDto.setUserid("itwill");
        noticeDao.insert(noticeDto);
        return "redirect:/notice/list";
    }

    @RequestMapping("/list")
    public ModelAndView list(HttpServletRequest req) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/list");

        int totalRowCount = noticeDao.totalRowCount();
        int numPerPage = 10;
        int pagePerBlock = 10;

        String pageNum = req.getParameter("pageNum");
        if (pageNum == null) {
            pageNum = "1";
        }

        int currentPage = Integer.parseInt(pageNum);
        int startRow = (currentPage - 1) * numPerPage + 1;
        int endRow = currentPage * numPerPage;

        double totcnt = (double) totalRowCount / numPerPage;
        int totalPage = (int) Math.ceil(totcnt);

        double d_page = (double) currentPage / pagePerBlock;
        int Pages = (int) Math.ceil(d_page) - 1;
        int startPage = Pages * pagePerBlock;
        int endPage = startPage + pagePerBlock + 1;

        if (endPage > totalPage) {
            endPage = totalPage + 1;
        }

        List<NoticeDTO> list;
        if (totalRowCount > 0) {
            list = noticeDao.list2(startRow, endRow);
        } else {
            list = Collections.emptyList();
        }

        mav.addObject("list", list);
        mav.addObject("totalPage", totalPage);
        mav.addObject("startPage", startPage);
        mav.addObject("endPage", endPage);
        mav.addObject("currentPage", currentPage);

        return mav;
    }

    @RequestMapping("/evl")
    public ModelAndView evl(HttpServletRequest req) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/evl");

        int totalRowCount2 = noticeDao.totalRowCount2();
        int numPerPage = 10;
        int pagePerBlock = 10;

        String pageNum = req.getParameter("pageNum");
        if (pageNum == null) {
            pageNum = "1";
        }

        int currentPage = Integer.parseInt(pageNum);
        int startRow = (currentPage - 1) * numPerPage + 1;
        int endRow = currentPage * numPerPage;

        double totcnt = (double) totalRowCount2 / numPerPage;
        int totalPage = (int) Math.ceil(totcnt);

        double d_page = (double) currentPage / pagePerBlock;
        int Pages = (int) Math.ceil(d_page) - 1;
        int startPage = Pages * pagePerBlock;
        int endPage = startPage + pagePerBlock + 1;

        if (endPage > totalPage) {
            endPage = totalPage + 1;
        }

        List<NoticeDTO> evl;
        if (totalRowCount2 > 0) {
            evl = noticeDao.evl2(startRow, endRow);
        } else {
            evl = Collections.emptyList();
        }

        mav.addObject("evl", evl);
        mav.addObject("totalPage", totalPage);
        mav.addObject("startPage", startPage);
        mav.addObject("endPage", endPage);
        mav.addObject("evlPageNum", currentPage); // 현재 페이지 번호 추가
        mav.addObject("evlStartPage", startPage); // 시작 페이지 번호 추가
        mav.addObject("evlEndPage", endPage); // 끝 페이지 번호 추가

        return mav;
    }

    @GetMapping("/search")
    public ModelAndView search(@RequestParam(defaultValue = "") String title) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/list");
        mav.addObject("list", noticeDao.search(title));
        mav.addObject("title", title);
        return mav;
    }

    @GetMapping("/searching")
    public ModelAndView searching(@RequestParam(defaultValue = "") String title) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/evl");
        mav.addObject("evl", noticeDao.searching(title));
        mav.addObject("title", title);
        return mav;
    }

    @GetMapping("/detail")
    public ModelAndView detail(@RequestParam("noticeid") int noticeid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/detail");
        mav.addObject("notice", noticeDao.detail(noticeid));
        return mav;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("noticeid") int noticeid) {
        noticeDao.delete(noticeid);
        return "redirect:/notice/list";
    }

    @GetMapping("/update")
    public ModelAndView updateForm(@RequestParam("noticeid") int noticeid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("notice/update");
        mav.addObject("notice", noticeDao.detail(noticeid));
        return mav;
    }

    @PostMapping("/update")
    public String update(@ModelAttribute NoticeDTO notice) {
        noticeDao.update(notice);
        return "redirect:/notice/list";
    }
    
    
    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("file") MultipartFile file) {
        String imageUrl = "";
        try {
            // 프로젝트 경로를 기반으로 저장 경로 설정
            String uploadDir = new File("src/main/webapp/storage").getAbsolutePath();
            String fileName = file.getOriginalFilename();
            File dest = new File(uploadDir + File.separator + fileName);
            file.transferTo(dest);

            // 이미지 URL 설정 (웹 서버의 경로로 맞춰야 함)
            imageUrl = "/storage/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return imageUrl;
    }

}
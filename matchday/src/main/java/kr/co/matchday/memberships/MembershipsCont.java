package kr.co.matchday.memberships;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/memberships")
public class MembershipsCont {

    @Autowired
    private MembershipsDAO membershipsDao;

    @RequestMapping("/list")
    public ModelAndView list() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("memberships/list");
        mav.addObject("list", membershipsDao.list());
        return mav;
    }

    @GetMapping("/write")
    public String write() {
        return "memberships/write";
    }

    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> map,
                         @RequestParam("img") MultipartFile img,
                         HttpServletRequest req) {
        ServletContext application = req.getServletContext();
        String basePath = application.getRealPath("/storage/memberships");

        String filename = "-";
        long filesize = 0;

        try {
            if (!img.isEmpty()) {
                filesize = img.getSize();
                filename = uploadFile(basePath, img);
            }

            MembershipsDTO membershipsDto = new MembershipsDTO();
            membershipsDto.setMembershipid(UUID.randomUUID().toString()); // UUID를 사용하여 membershipid 생성
            membershipsDto.setMembershipname((String) map.get("membershipname"));
         /* membershipsDto.setPrice(parseInteger((String) map.get("price"))); */
            membershipsDto.setPrice(parseInteger((String) map.get("price")));
            membershipsDto.setStartdate(parseDate((String) map.get("startdate")));
            membershipsDto.setEnddate(parseDate((String) map.get("enddate")));
            membershipsDto.setNotes((String) map.getOrDefault("notes", ""));
            membershipsDto.setDiscountamount(parseInteger((String) map.get("discountamount")));
            membershipsDto.setFilename(filename);
            membershipsDto.setFilesize(filesize);

            membershipsDao.insert(membershipsDto);

        } catch (Exception e) {
            e.printStackTrace();
            // 예외 처리 로직 추가
        }

        return "redirect:/memberships/list";
    }

    @GetMapping("/detail")
    public ModelAndView detail(@RequestParam("membershipid") String membershipid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("memberships/detail");
        mav.addObject("memberships", membershipsDao.detail(membershipid));
        return mav;
    }

    @GetMapping("/update")
    public ModelAndView update(@RequestParam("membershipid") String membershipid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("memberships/update");
        mav.addObject("memberships", membershipsDao.read(membershipid));
        return mav;
    }

    @PostMapping("/updateproc")
    public String updateproc(@RequestParam Map<String, Object> map,
                             @RequestParam(value = "img", required = false) MultipartFile img,
                             HttpServletRequest req) {
        ServletContext application = req.getServletContext();
        String basePath = application.getRealPath("/storage/memberships");

        String filename = "-";
        long filesize = 0;

        try {
            if (img != null && !img.isEmpty()) {
                filename = uploadFile(basePath, img);
                filesize = img.getSize();
            } else {
                filename = (String) map.get("existingFilename");
                // Check if existingFilesize is null or empty before parsing
                String existingFilesizeStr = (String) map.get("existingFilesize");
                if (existingFilesizeStr != null && !existingFilesizeStr.isEmpty()) {
                    filesize = Long.parseLong(existingFilesizeStr);
                }
            }

            MembershipsDTO membershipsDto = new MembershipsDTO();
            membershipsDto.setMembershipid((String) map.get("membershipid"));
            membershipsDto.setMembershipname((String) map.get("membershipname"));
            membershipsDto.setPrice(parseInteger((String) map.get("price")));
            membershipsDto.setStartdate(parseDate((String) map.get("startdate")));
            membershipsDto.setEnddate(parseDate((String) map.get("enddate")));
            membershipsDto.setFilename(filename);
            membershipsDto.setFilesize(filesize);

            membershipsDao.update(membershipsDto);

            // 기존 파일 삭제 (선택된 경우에만)
            if (img != null && !img.isEmpty() && !filename.equals((String) map.get("existingFilename"))) {
                deleteFile(basePath, (String) map.get("existingFilename"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/memberships/list";
    }

    private String uploadFile(String basePath, MultipartFile img) throws IOException {
        String originalFilename = img.getOriginalFilename();
        String filename = originalFilename;
        File file = new File(basePath, originalFilename);
        int i = 1;
        while (file.exists()) {
            int lastDot = originalFilename.lastIndexOf(".");
            filename = originalFilename.substring(0, lastDot) + "_" + i + originalFilename.substring(lastDot);
            file = new File(basePath, filename);
            i++;
        }
        img.transferTo(file);
        return filename;
    }

    private void deleteFile(String basePath, String filename) {
        if (filename != null && !filename.isEmpty()) {
            File existingFile = new File(basePath, filename);
            if (existingFile.exists()) {
                existingFile.delete();
            }
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0; // 기본값으로 0을 반환
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return 0; // 기본값으로 0을 반환
        }
    }

    private Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return dateFormat.parse(value);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    
    @GetMapping("/delete")
    public String delete(@RequestParam("membershipid") String membershipid, HttpServletRequest req) {
        // 파일 이름 가져오기
        String filename = membershipsDao.filename(membershipid);

        try {
            if (filename != null && !filename.equals("-")) {
                // 서블릿 컨텍스트에서 경로 가져오기
                ServletContext application = req.getServletContext();
                String basePath = application.getRealPath("/storage/memberships");

                // 파일 경로 생성
                File file = new File(basePath, filename);
                if (file.exists()) {
                    // 파일 삭제
                    file.delete();
                }
            }

            // 데이터베이스에서 행 삭제
            membershipsDao.delete(membershipid);

        } catch (Exception e) {
            e.printStackTrace();
            // 예외 처리 로직 추가
        }

        return "redirect:/memberships/list";
    }//delete() end
    
    
    
}//class end

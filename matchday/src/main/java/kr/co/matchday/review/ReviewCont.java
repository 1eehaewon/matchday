package kr.co.matchday.review;

import java.io.File;
import java.io.IOException;
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
import kr.co.matchday.cart.CartDTO;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;

@Controller
@RequestMapping("/review")
public class ReviewCont {

	public ReviewCont() {
		System.out.println("-----ReviewCont() 객체 생성됨");
	}//end
	
	@Autowired
	private ReviewDAO reviewDao;
	
	@Autowired
    private GoodsDAO goodsDao;
/*
	@GetMapping("/write")
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto) {
        return "review/write";
    }//write end
*/
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
    }//write end
	
	
	@GetMapping("/list")
    public String list(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        /*
        List<GoodsDTO> goodsList = goodsDao.list();
        List<ReviewDTO> reviewList = reviewDao.list();
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("reviewList", reviewList);
        return "review/list";
        */
        List<ReviewDTO> reviewList = reviewDao.list();
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("goodsList", goodsList);
        
        return "review/list";
        
    }//list end
	
	
    @PostMapping("/insert")
    public String insert(@ModelAttribute ReviewDTO reviewDto, HttpSession session,
    					 @RequestParam("img") List<MultipartFile> imgs,
    					HttpServletRequest req,
    					@RequestParam("goodsid") String goodsid,
    					String basePath) {
    	// 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        
        // 기타 필요한 정보 설정 (userid, matchid, goodsid)
        reviewDto.setUserid(userid);
        reviewDto.setMatchid(reviewDto.getMatchid()); // 매치 ID 설정 필요
        reviewDto.setGoodsid(reviewDto.getGoodsid()); // 굿즈 ID 설정 필요

        // 리뷰 날짜 설정
        reviewDto.setReviewdate(reviewDto.getReviewdate());
        
        // grantedpoints 설정 (필요한 로직에 따라 설정)
        reviewDto.setGrantedpoints(reviewDto.getGrantedpoints());
    	
        reviewDao.insert(reviewDto);
        
     // 업로드 파일은 /storage폴더에 저장
        // 파일 처리를 위한 변수 초기화
        String filenames = "-";
        long totalFilesize = 0;
        
        // 다중 파일 업로드 처리
        for (MultipartFile img : imgs) {
            if (img.getSize() > 0 && !img.isEmpty()) { // 파일이 존재한다면
                long filesize = img.getSize();
                totalFilesize += filesize;
                
                try {
                    String originalFilename = img.getOriginalFilename();
                    String filename = originalFilename;
                    
                    File file = new File(basePath, filename);
                    int i = 1;
                    while (file.exists()) {
                        int lastDot = originalFilename.lastIndexOf(".");
                        filename = originalFilename.substring(0, lastDot) + "_" + i + originalFilename.substring(lastDot);
                        file = new File(basePath, filename);
                        i++;
                    }
                    
                    img.transferTo(file);
                    
                    // 파일명을 filenames에 추가
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
        
        // 리뷰 정보 업데이트 (파일명 및 파일 크기)
        reviewDao.update(reviewDto);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
 /*       
    	// 첨부된 파일 처리
        // -> 실제 파일 /storage 폴더에 저장
        ServletContext application = req.getServletContext();
        String basePath = application.getRealPath("/storage/review");
        

        // 업로드 파일은 /storage폴더에 저장
        // 파일 처리를 위한 변수 초기화
        String filename = "-";
        long filesize = 0;
        
        if (img.getSize() > 0 && img!=null && !img.isEmpty()) { // 파일이 존재한다면
            filesize = img.getSize();
            
            // 전송된 파일이 /storage 존재한다면 파일명을 리네임해서 저장하고, 파일명은 filename 변수에 저장
            // -> spring05_mymelon 프로젝트 참조
            
            try {
                String originalFilename = img.getOriginalFilename();
                filename = originalFilename;
                
                File file = new File(basePath, originalFilename); // 파일클래스에 해당파일 담기
                int i = 1;
                while (file.exists()) { // 파일이 존재한다면
                    int lastDot = originalFilename.lastIndexOf(".");
                    filename = originalFilename.substring(0, lastDot) + "_" + i + originalFilename.substring(lastDot); // sky_1.png
                    file = new File(basePath, filename);
                    i++;
                } // while end
                
                img.transferTo(file); // 파일 저장
                
            } catch (Exception e) {
                System.out.println(e);
            } // try end
            
        } // if end
    	
        reviewDto.setFilename(filename);
        reviewDto.setFilesize(filesize);
*/
    	
    	
    	/*
    	// 파일 업로드 처리
        if (file != null && !file.isEmpty()) {
            try {
                // 실제 서버에 파일 저장하는 로직 추가 (예: 파일명 중복 처리 필요)
                String filePath = "/storage/review/" + file.getOriginalFilename(); // 실제 저장할 경로 설정
                File dest = new File(filePath);
                file.transferTo(dest);
                // 리뷰ID와 함께 DB에 파일 정보 저장하는 로직 추가 필요
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (file != null) {
            System.out.println("Received file: " + file.getOriginalFilename());
        } else {
            System.out.println("No file received.");
        }
        
    	/*
    	// 파일 업로드 처리
        if (files != null && files.length > 0) {
            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    try {
                        // 실제 서버에 파일 저장하는 로직 추가 (예: 파일명 중복 처리 필요)
                        String filePath = "/storage/review" + file.getOriginalFilename(); // 실제 저장할 경로 설정
                        File dest = new File(filePath);
                        file.transferTo(dest);
                        // 리뷰ID와 함께 DB에 파일 정보 저장하는 로직 추가 필요
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    	*/
    	
       
        return "<script>window.opener.location.reload(); window.close();</script>";
        //return "redirect:/review/list";
    }//insert end

    
    
    
    
    
    
/*
    @PostMapping("/delete")
    public String delete(HttpServletRequest req) {
        String reviewid = req.getParameter("reviewid");

        String filename = reviewDao.filename(reviewid); // 삭제하고자 하는 파일명 가져오기

        if (filename != null && !filename.equals("-")) { // 첨부된 파일 삭제하기
            ServletContext application = req.getSession().getServletContext();
            String path = application.getRealPath("/storage/review");
            File file = new File(path + "\\" + filename);
            if (file.exists()) {
                file.delete();
            }//if end
        }//if end

        reviewDao.delete(reviewid); // 테이블 행 삭제						

        return "redirect:/goods/detail";
    }//delete end
*/    
    
    @GetMapping("/filename/{reviewid}")
    public String getFilename(@PathVariable String reviewid) {
    	return reviewDao.filename(reviewid);
    }//filename end
    
    
    
    
    
  
    
    
    
    
    
    
    
    
    
	
    /*
	//summernote 사진 인서트
    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest req) {
        String imageUrl = "";
        try {
            ServletContext application = req.getServletContext();
            String basePath = application.getRealPath("/storage/review");

            String fileName = file.getOriginalFilename();
            File dest = new File(basePath + File.separator + fileName);
            file.transferTo(dest);

            imageUrl = "/storage/review/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return imageUrl;
    }//uploadImage end
	*/
	
	
	
	
}//class end

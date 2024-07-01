package kr.co.matchday.goods;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import net.utility.Utility;

@Controller
@RequestMapping("/goods")
public class GoodsCont {

	public GoodsCont() {
		System.out.println("-----GoodsCont() 객체 생성됨");
	}//end

	@Autowired
    private GoodsDAO goodsDao;

	@RequestMapping("/list")
	/* @GetMapping("/list") */
    public ModelAndView list() {
        List<GoodsDTO> goodsList = goodsDao.list();
        ModelAndView mav = new ModelAndView();
        mav.setViewName("goods/list");
        mav.addObject("list", goodsList);
        return mav;
    }

    @GetMapping("/write")
    public String write(@ModelAttribute("goodsDto") GoodsDTO goodsDto) {
        return "goods/write";
    }

    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> map,       // write.jsp의 "productname", "price", "description"
                         @RequestParam("img") MultipartFile img,      // write.jsp의 "img"
                         HttpServletRequest req) {
        
        // 첨부된 파일 처리
        // -> 실제 파일 /storage 폴더에 저장
        // -> 저장된 파일 관련 정보는 media 테이블에 저장
        ServletContext application = req.getServletContext();
        String basePath = application.getRealPath("/storage");
        
        // 업로드 파일은 /storage폴더에 저장
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
        
        // Create and populate GoodsDTO object
        GoodsDTO goodsDTO = new GoodsDTO();
        goodsDTO.setGoodsid((String) map.get("goodsid"));                  // 굿즈 ID
        goodsDTO.setCategory((String) map.get("category"));                // 굿즈 카테고리
        goodsDTO.setProductname((String) map.get("productname"));         // 상품명
        goodsDTO.setDescription((String) map.get("description"));          // 설명
        goodsDTO.setSize((String) map.get("size"));                        // 사이즈
        goodsDTO.setPrice(Integer.parseInt((String) map.get("price")));    // 가격
        goodsDTO.setStockquantity(Integer.parseInt((String) map.get("stockquantity"))); // 재고 수량
        goodsDTO.setIssoldout((String) map.get("issoldout"));              // 품절 여부
        goodsDTO.setFilename(filename);                                    // 파일 이름
        goodsDTO.setFilesize(filesize);                                    // 파일 크기
        
        // Insert the goodsDTO object into the database
        goodsDao.insert(goodsDTO);
        
        return "redirect:/goods/list";
    } // insert end


    @GetMapping("/search")
    public ModelAndView search(@RequestParam(defaultValue = "") String productname) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("goods/list");
        mav.addObject("list", goodsDao.search(productname));
        mav.addObject("productname", productname);
        return mav;
    }//search end

    @GetMapping("/detail/{goodsid}")
    public ModelAndView detail(@PathVariable String goodsid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("goods/detail");
        mav.addObject("goods", goodsDao.detail(goodsid));
        return mav;
    }//detail end

    @PostMapping("/update")
    public String update(@ModelAttribute GoodsDTO goodsDTO,
                         @RequestParam(value = "img", required = false) MultipartFile img,
                         HttpServletRequest req) {

        String goodsid = goodsDTO.getGoodsid();
        GoodsDTO oldGoods = goodsDao.detail(goodsid); // Retrieve old goods details

        String filename = oldGoods.getFilename();
        long filesize = oldGoods.getFilesize();

        if (img!=null && !img.isEmpty()) { //첨부된 파일이 존재한다면
            ServletContext application = req.getServletContext();
            String basePath = application.getRealPath("/storage");

            try {
                filesize = img.getSize();
                String originalFilename = img.getOriginalFilename();
                filename = originalFilename;
                File file = new File(basePath, originalFilename); //파일클래스에 해당파일 담기

                int i = 1;
                while (file.exists()) { //파일이 존재한다면
                    int lastDot = originalFilename.lastIndexOf(".");
                    filename = originalFilename.substring(0, lastDot) + "_" + i + originalFilename.substring(lastDot);
                    file = new File(basePath, filename);
                    i++;
                }//while end

                img.transferTo(file); // 신규 파일 저장
                Utility.deleteFile(basePath, oldGoods.getFilename()); // 기존 파일 삭제

            } catch (Exception e) {
                System.out.println(e);
            }//try end
        }//if end

        goodsDTO.setFilename(filename);
        goodsDTO.setFilesize(filesize);

        goodsDao.update(goodsDTO); // Update goods information

        return "redirect:/goods/list";
    }//update end

    @PostMapping("/delete")
    public String delete(HttpServletRequest req) {
        String goodsid = req.getParameter("goodsid");

        String filename = goodsDao.filename(goodsid); // 삭제하고자 하는 파일명 가져오기

        if (filename != null && !filename.equals("-")) { // 첨부된 파일 삭제하기
            ServletContext application = req.getSession().getServletContext();
            String path = application.getRealPath("/storage");
            File file = new File(path + "\\" + filename);
            if (file.exists()) {
                file.delete();
            }//if end
        }//if end

        goodsDao.delete(goodsid); // 테이블 행 삭제

        return "redirect:/goods/list";
    }//delete end

    @GetMapping("/filename/{goodsid}")
    public String getFilename(@PathVariable String goodsid) {
        return goodsDao.filename(goodsid);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}//class end

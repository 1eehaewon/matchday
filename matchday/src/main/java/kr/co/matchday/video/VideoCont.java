package kr.co.matchday.video;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/video")
public class VideoCont {

    @Autowired
    private VideoDAO videoDao;

    public VideoCont() {
        System.out.println("-----VideoCont() 객체 생성됨");
    }

    @RequestMapping("/list")
    public ModelAndView list(@RequestParam(defaultValue = "1") int page) {
        int pageSize = 9;
        int offset = (page - 1) * pageSize;

        int totalRecords = videoDao.countVideos();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        Map<String, Integer> params = new HashMap<>();
        params.put("limit", pageSize);
        params.put("offset", offset);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("video/list");
        mav.addObject("list", videoDao.listWithPaging(params));
        mav.addObject("currentPage", page);
        mav.addObject("totalPages", totalPages);
        return mav;
    }
    
    @GetMapping("/write")
    public String write() {
        return "video/write";
    }//write() end

    @PostMapping("/insert")
    public String insert(VideoDTO videoDTO, HttpServletRequest req) {
        videoDao.insert(videoDTO);
        return "redirect:/video/list";
    }//insert() end
    
    
    //@GetMapping("/detail/{video_code}")
    //public ModelAndView detail(@PathVariable int video_code) {
    @GetMapping("/detail")
    public ModelAndView detail(@RequestParam("video_code") int video_code) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("video/detail");
        mav.addObject("detail", videoDao.detail(video_code));
        return mav;
    }//detail() end
    
    
    @GetMapping("/update")
    public ModelAndView updatedetail(@RequestParam("video_code") int video_code) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("video/update");
        mav.addObject("detail", videoDao.detail(video_code));
        return mav;
    }//updatedetail() end

    @PostMapping("/updateproc")
    public String update(@ModelAttribute VideoDTO videoDTO) {
        videoDao.update(videoDTO);
        return "redirect:/video/list";
    }//update() end
    

    //참조 spring09_myshop 프로젝트 ProductCont.java 참조
    //@PostMapping("/delete/{video_code}")
    //public String delete(@PathVariable("video_code") int video_code) {
    @GetMapping("/delete")
    public String delete(@RequestParam("video_code") int video_code) {
    	//System.out.println("11111111111");
        videoDao.delete(video_code);
        return "redirect:/video/list";
    }//delete() end
    
    
    
    @GetMapping("/search")
    public ModelAndView search(@RequestParam(defaultValue = "") String video_name) {
 	   ModelAndView mav = new ModelAndView();
 	   mav.setViewName("video/list");
 	   mav.addObject("list", videoDao.search(video_name));
 	   mav.addObject("video_name", video_name); //검색어
 	   return mav;
    }//search() end 

    @GetMapping("/recentVideos")
    @ResponseBody
    public List<VideoDTO> getRecentVideos() {
        return videoDao.getRecentVideos();
    }

   
}//class end

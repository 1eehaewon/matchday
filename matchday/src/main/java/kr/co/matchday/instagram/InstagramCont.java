package kr.co.matchday.instagram;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpServletRequest;
import kr.co.matchday.video.VideoDTO;

@Controller
@RequestMapping("/instagram")
public class InstagramCont {

    public InstagramCont() {
        System.out.println("-----InstagramCont() 객체 생성됨");
    }//class() end

    @Autowired
    private InstagramDAO instagramDao;

    @RequestMapping("/list")
    public ModelAndView list() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("instagram/list");
        mav.addObject("list", instagramDao.list());
        return mav;
    }//list() end

    @GetMapping("/write")
    public String write() {
        return "instagram/write";
    }//write() end

    @PostMapping("/insert")
    public String insert(InstagramDTO instagramDTO, HttpServletRequest req) {
        instagramDao.insert(instagramDTO);
        return "redirect:/instagram/list";
    }//insert() end
    
    @GetMapping("/detail")
    public ModelAndView detail(@RequestParam("instagram_code") int instagram_code) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("instagram/detail");
        mav.addObject("detail", instagramDao.detail(instagram_code));
        return mav;
    }//detail()
    
    @GetMapping("/update/{instagram_code}")
    public ModelAndView updatedetail(@PathVariable int instagram_code) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("instagram/update");
        mav.addObject("detail", instagramDao.detail(instagram_code));
        return mav;
    }//updatedetail() end
  
    @PostMapping("/update")
    public String update(@ModelAttribute InstagramDTO instagramDTO) {
    	instagramDao.update(instagramDTO);
        return "redirect:/instagram/list";
    }//update() end
    
    @GetMapping("/delete")
    public String delete(@RequestParam("instagram_code") int instagram_code) {
    	instagramDao.delete(instagram_code);
        return "redirect:/instagram/list";
    }//delete() end
    
    
}//class end

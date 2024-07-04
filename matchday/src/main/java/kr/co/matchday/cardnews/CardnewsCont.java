package kr.co.matchday.cardnews;

import java.util.HashMap;
import java.util.Map;

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

@Controller
@RequestMapping("/cardnews")
public class CardnewsCont {

    @Autowired
    private CardnewsDAO cardnewsDao;

    public CardnewsCont() {
        System.out.println("-----CardnewsCont() 객체 생성됨");
    }
 
    @GetMapping("/list")
    public String list() {
        return "cardnews/list";
    }//list() end
      
    @GetMapping("/write")
    public String write() {
        return "cardnews/write";
    }//write() end

   
   
}//class end

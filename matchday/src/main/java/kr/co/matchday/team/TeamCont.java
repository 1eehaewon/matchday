package kr.co.matchday.team;

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
import kr.co.matchday.player.PlayerDAO;

@Controller
@RequestMapping("/team")
public class TeamCont {

    @Autowired
    private TeamDAO teamDao;
    
    @Autowired
    private PlayerDAO playerDao;

    public TeamCont() {
        System.out.println("----TeamCont() 객체생성됨");
    }

    
    @GetMapping("/write")
    public String write() {
        return "team/write";
    }
    
    
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> map
                        ,@RequestParam("img") MultipartFile img
                        ,HttpServletRequest req) {
    	
    	ServletContext application = req.getServletContext();
        String basePath=application.getRealPath("/storage/teams");
        
        String filename = "-";
        long filesize = 0;
        
        if(img.getSize()>0 && img!=null && !img.isEmpty()) { //파일이 존재한다면
            filesize = img.getSize();
            
            //전송된 파일이 /storage존재한다면 파일명을 리네임해서 저장하고, 파일명은 filename변수에 저장
            //->spring05_mymelon 프로젝트 참조 
            try {
                String o_poster = img.getOriginalFilename();
                filename = o_poster;
                
                File file = new File(basePath, o_poster); //파일클래스에 해당파일 담기
                int i = 1;
                while(file.exists()) { //파일이 존재한다면
                    int lastDot = o_poster.lastIndexOf(".");
                    filename = o_poster.substring(0, lastDot) + "_" + i + o_poster.substring(lastDot);
                    file = new File(basePath, filename);
                    i++;
                }//while end
                
                img.transferTo(file); //파일 저장
                
            }catch (Exception e) {
                System.out.println(e);
            }//try end      
        }//if end
        
        map.put("filename", filename);
        map.put("filesize", filesize);
        
        teamDao.insert(map);
                
        return "redirect:/team/list";
    }//insert() end
    
    
    @RequestMapping("/list")
    public ModelAndView list() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("team/list");
        mav.addObject("list", teamDao.list());
        return mav;
    }//list() end
    
    
    @GetMapping("/detail/{teamname}")
    public ModelAndView detail(@PathVariable String teamname) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("team/detail");
        
        // 팀 정보 가져오기
        Map<String, Object> team = teamDao.detail(teamname);
        mav.addObject("team", team);
        
        // 선수 목록 가져오기
        List<Map<String, Object>> players = playerDao.list(teamname);
        mav.addObject("players", players);

        return mav;
    }

    

}//class end
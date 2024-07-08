package kr.co.matchday.player;

import java.io.File;
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
import kr.co.matchday.notice.NoticeDTO;
import net.utility.Utility;

@Controller
@RequestMapping("/player")
public class PlayerCont {

    @Autowired
    private PlayerDAO playerDao;

    public PlayerCont() {
        System.out.println("-----PlayerCont() 객체생성됨");
    }
    
    
    @GetMapping("/write")
    public String write() {
        return "player/write";
    }
    
    
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> map
                        ,@RequestParam("img") MultipartFile img
                        ,HttpServletRequest req) {
    	
    	ServletContext application = req.getServletContext();
        String basePath=application.getRealPath("/storage/players");
        
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
        
        playerDao.insert(map);
                
        return "redirect:/team/list";
    }//inserts() end
    
    
    @GetMapping("/team/detail/{teamname}/list")
    public ModelAndView listByTeam(@PathVariable("teamname") String teamname) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("player/list");
        mav.addObject("teamname", teamname);
        mav.addObject("players", playerDao.list(teamname));
        return mav;
    }
    
    
    @GetMapping("/detail/{playerid}")
    public ModelAndView detail(@PathVariable("playerid") String playerid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("player/detail"); // detail.jsp 혹은 detail.html과 같은 뷰 파일
        Map<String, Object> player = playerDao.detail(playerid);
        mav.addObject("player", player);
        return mav;
    }
    
    
    @GetMapping("/update")
    public ModelAndView showUpdateForm(@RequestParam("playerid") String playerid) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("player/update");
        Map<String, Object> player = playerDao.detail(playerid);
        mav.addObject("player", player);
        return mav;
    }
    
    
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> map
                        ,@RequestParam("img") MultipartFile img
                        ,HttpServletRequest req) {
        
    	String playerid = map.get("playerid").toString();
        Map<String, Object> oldplayer = playerDao.detail(playerid); 
        
        String filename = "-";
        long filesize = 0;
        
        if(img.getSize()>0 && img!=null && !img.isEmpty()) {
            //첨부된 파일이 존재한다면
            ServletContext application = req.getServletContext();
            String basePath=application.getRealPath("/storage/players");
            
            try {
                filesize = img.getSize();
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
                
                img.transferTo(file); //신규 파일 저장
                Utility.deleteFile(basePath, oldplayer.get("FILENAME").toString()); //기존 파일 삭제        
                
            }catch (Exception e) {
                System.out.println(e);
            }//try end
            
        } else {
            //첨부된 파일이 없다면
            filename = oldplayer.get("FILENAME").toString();
            filesize = Long.parseLong(oldplayer.get("FILESIZE").toString());
        }//if end
        
        map.put("filename", filename);
        map.put("filesize", filesize);
        playerDao.update(map); 
        return "redirect:/team/list";
        
    }//update() end
    
    //현모님이 실행하고자 하는 SQL문을 적어보셍
    //delete from playerid where playerid = 'Rodrygo'
    @GetMapping("/delete")
    public String delete(@RequestParam("playerid") String playerid, HttpServletRequest req) {
        
      //삭제하고자 하는 파일명 가져오기
        String filename=playerDao.filename(playerid);
        
        //첨부된 파일 삭제하기
        if(filename != null && !filename.equals("-")) {
            ServletContext application=req.getSession().getServletContext();
            String path=application.getRealPath("/storage/players");  //실제 물리적인 경로
            File file=new File(path + "\\" + filename);
            if(file.exists()) {
                file.delete();
            }//if end
        }//if end
        
        playerDao.delete(playerid); //테이블 행 삭제
        
        return "redirect:/team/list";
    }//delete() end


}//class end
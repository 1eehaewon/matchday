package kr.co.matchday.stadium;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class StadiumCont {

    @Autowired
    private StadiumDAO stadiumDAO;

    // 경기장 등록 페이지로 이동
    @GetMapping("/stadium")
    public ModelAndView showStadiumRegistrationPage() {
        List<StadiumDTO> stadiumList = stadiumDAO.getAllStadiums();
        ModelAndView mav = new ModelAndView("admin/stadium");
        mav.addObject("stadiumList", stadiumList);
        return mav;
    }

    // 경기장 등록 처리
    @PostMapping("/stadium/register")
    public ModelAndView registerStadium(StadiumDTO stadiumDTO, MultipartFile stadiumImageFile) {
        String nextStadiumId = stadiumDAO.getNextStadiumId();
        stadiumDTO.setStadiumId(nextStadiumId);

        if (!stadiumImageFile.isEmpty()) {
            try {
                stadiumDTO.setStadiumImage(stadiumImageFile.getBytes());
            } catch (IOException e) {
                e.printStackTrace();
                // 에러 처리 로직 추가 가능
            }
        } else {
            stadiumDTO.setStadiumImage(null);
        }

        stadiumDAO.insertStadium(stadiumDTO);
        return new ModelAndView("redirect:/admin/stadium");
    }

    @PostMapping("/stadium")
    public ModelAndView registerStadium(@ModelAttribute StadiumDTO stadiumDTO) {
        stadiumDAO.insertStadium(stadiumDTO);
        return new ModelAndView("redirect:/admin/stadium");
    }
}
